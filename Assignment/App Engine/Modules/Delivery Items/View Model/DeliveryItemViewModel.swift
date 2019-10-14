import Foundation
import UIKit
import CoreData

class DeliveryItemViewModel {
    
    internal typealias completion           = () -> Void
    internal typealias completionWithError  = (Error) -> Void

    var handleCompletionWithSuccess : completion?
    var handleCompletionWithNoData  : completion?
    var handleCompletionWithError   : completionWithError?
    var handleNextPageLoading       : completion?
    var handleInternetError         : completion?

    // MARK: - Variables
    var deliveries = [DeliveryItem]()
    var isRequestInProgress = false
    var offset = 0
    
    //Dependency Injection to make CoredataManager, ApiManager & Reachability Testable using Mocking
    var apiManager: APIManagerProtocol
    var coreDataManager: CoredataManagerProtocol
    var reachability: ReachabilityProtocol
    
    init(_ apiManager: APIManagerProtocol = APIManager(),
         coreDataManager: CoredataManagerProtocol = CoreDataManager.shared,
         reachability: ReachabilityProtocol = Reachability()) {
        self.apiManager = apiManager
        self.coreDataManager = coreDataManager
        self.reachability = reachability
    }

    // MARK: - Fetch Deliveries from Server
    private func fetchDeliveriesFromServer(isRefreshData refresh: Bool) {
        guard reachability.isInternetConnected() else {
            handleInternetError?()
            return
        }
        if self.deliveries.isEmpty && !refresh {
            CommonClass.shared.showLoader()
        }
        isRequestInProgress = true
        offset = refresh ? 0 : deliveries.count
        apiManager.getDeliveriesFromServer(offset: offset, limit: fetchLimit) {[weak self] (result: Result<[DeliveryItem], Error>) in
            self?.isRequestInProgress = false
            switch result {
            case .success(let items):
                guard !items.isEmpty else {
                    self?.handleCompletionWithNoData?()
                    return
                }
                refresh ?
                    self?.onSuccessRefreshItems(withItems: items) :
                    self?.onSuccessLoadMoreItems(withItems: items, fromDB: false)
            case .failure(let error):
                self?.handleCompletionWithError?(error)
            }
        }
    }
    
    // MARK: - Fetch Deliveries From Local DB
    private func fetchDeliveriesFromLocalDB() {
        offset = deliveries.count
        self.coreDataManager.fetchDeliveryItemFromLocalDB(offset: offset) {[weak self] (items, err) in
            guard err == nil else {
                self?.handleCompletionWithError?(err!)
                return
            }
            items.isEmpty ?
                self?.fetchDeliveriesFromServer(isRefreshData: false) :
                self?.onSuccessLoadMoreItems(withItems: items, fromDB: true)
        }
    }
    
    // MARK: - Handle Refresh Success
    private func onSuccessRefreshItems(withItems items: [DeliveryItem]) {
        deliveries = items
        self.handleCompletionWithSuccess?()
        self.coreDataManager.deleteDeliveryItemFromLocalDB {[weak self] (error) in
            guard error == nil else {
                self?.handleCompletionWithError?(error!)
                return
            }
            self?.coreDataManager.saveDeliveryItemToLocalDB(items: items)
        }
    }
    
    // MARK: - Handle Load More Item Success
    private func onSuccessLoadMoreItems(withItems items: [DeliveryItem], fromDB isFromDB: Bool) {
        deliveries.append(contentsOf: items)
        self.handleCompletionWithSuccess?()
        guard !isFromDB else {
            return
        }
        self.coreDataManager.saveDeliveryItemToLocalDB(items: items)
    }
}

// MARK: - Extension DeliveryItemViewModel
extension DeliveryItemViewModel: DeliveryItemViewModelProtocol {
    
    // MARK: - Load Data
    func loadData() {
        guard !isRequestInProgress else {
            return
        }
        self.fetchDeliveriesFromLocalDB()
    }
    
    // MARK: - Refresh Data
    func refreshData() {
        guard !isRequestInProgress else {
            return
        }
        self.fetchDeliveriesFromServer(isRefreshData: true)
    }
    
    // MARK: - Check Bottom Dragging
    func checkBottomDragging(tblOffset: CGFloat, maxHght: CGFloat) {
        if tblOffset >= maxHght && !(deliveries.isEmpty) {
            handleNextPageLoading?()
            loadData()
        }
    }
    
    // MARK: - Get Delivery Detail View Model
    func getDeliveryDetailViewModel(fromIndex index: Int) -> DeliveryDetailViewModel? {
        return (deliveries.count > index) ?
            DeliveryDetailViewModel.init(withItem: deliveries[index]) :
            nil
    }
}
