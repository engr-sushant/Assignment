import Foundation
import UIKit
import CoreData

class DeliveryItemViewModel {
    
    internal typealias Completion           = (_ loaderType: ProgressLoaderType) -> Void
    internal typealias CompletionWithError  = (_ loaderType: ProgressLoaderType, _ error: Error) -> Void

    var handleCompletionWithSuccess: Completion?
    var handleCompletionWithNoData: Completion?
    var handleCompletionWithError: CompletionWithError?
    var handleNextPageLoading: Completion?
    var handleInternetError: Completion?

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
    private func fetchDeliveriesFromServer(isRefreshData refresh: Bool, loaderType: ProgressLoaderType) {
        guard reachability.isInternetConnected() else {
            handleInternetError?(loaderType)
            return
        }
        if self.deliveries.isEmpty && !refresh {
            CommonClass.shared.showLoader()
        }
        isRequestInProgress = true
        offset = refresh ? 0 : deliveries.count
        apiManager.getDeliveriesFromServer(offset: offset, limit: APIQueryConstant.fetchLimit) {[weak self] (result: Result<[DeliveryItem], Error>) in
            self?.isRequestInProgress = false
            switch result {
            case .success(let items):
                guard !items.isEmpty else {
                    self?.handleCompletionWithNoData?(loaderType)
                    return
                }
                refresh ?
                    self?.onSuccessRefreshItems(withItems: items, loaderType: loaderType) :
                    self?.onSuccessLoadMoreItems(withItems: items, fromDB: false, loaderType: loaderType)
            case .failure(let error):
                self?.handleCompletionWithError?(loaderType, error)
            }
        }
    }
    
    // MARK: - Fetch Deliveries From Local DB
    private func fetchDeliveriesFromLocalDB(withLoader loaderType: ProgressLoaderType) {
        offset = deliveries.count
        self.coreDataManager.fetchDeliveryItemsFromLocalDB(offset: offset) {[weak self] (items, err) in
            guard err == nil else {
                self?.handleCompletionWithError?(loaderType, err!)
                return
            }
            items.isEmpty ?
                self?.fetchDeliveriesFromServer(isRefreshData: false, loaderType: loaderType) :
                self?.onSuccessLoadMoreItems(withItems: items, fromDB: true, loaderType: loaderType)
        }
    }
    
    // MARK: - Handle Refresh Success
    private func onSuccessRefreshItems(withItems items: [DeliveryItem], loaderType: ProgressLoaderType) {
        deliveries = items
        self.handleCompletionWithSuccess?(loaderType)
        self.coreDataManager.deleteDeliveryItemsFromLocalDB {[weak self] (error) in
            guard error == nil else {
                self?.handleCompletionWithError?(loaderType, error!)
                return
            }
            self?.coreDataManager.saveDeliveryItemsToLocalDB(items: items)
        }
    }
    
    // MARK: - Handle Load More Item Success
    private func onSuccessLoadMoreItems(withItems items: [DeliveryItem], fromDB isFromDB: Bool, loaderType: ProgressLoaderType) {
        deliveries.append(contentsOf: items)
        self.handleCompletionWithSuccess?(loaderType)
        guard !isFromDB else {
            return
        }
        self.coreDataManager.saveDeliveryItemsToLocalDB(items: items)
    }
}

// MARK: - Extension DeliveryItemViewModel
extension DeliveryItemViewModel: DeliveryItemViewModelProtocol {
    
    // MARK: - Load Data
    func loadData(withLoader loaderType: ProgressLoaderType) {
        guard !isRequestInProgress else {
            return
        }
        self.fetchDeliveriesFromLocalDB(withLoader: loaderType)
    }
    
    // MARK: - Refresh Data
    func refreshData(withLoader loaderType: ProgressLoaderType) {
        guard !isRequestInProgress else {
            return
        }
        self.fetchDeliveriesFromServer(isRefreshData: true, loaderType: loaderType)
    }
    
    // MARK: - Check Bottom Dragging
    func checkBottomDragging(tblOffset: CGFloat, maxHght: CGFloat) {
        if tblOffset >= maxHght && !(deliveries.isEmpty) {
            handleNextPageLoading?(.BottomDraggingLoader)
            loadData(withLoader: .BottomDraggingLoader)
        }
    }
    
    // MARK: - Get Delivery Detail View Model
    func getDeliveryDetailViewModel(fromIndex index: Int) -> DeliveryDetailViewModel? {
        return (deliveries.count > index) ?
            DeliveryDetailViewModel.init(withItem: deliveries[index]) :
            nil
    }
}
