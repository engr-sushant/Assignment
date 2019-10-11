import Foundation
import UIKit
import CoreData

class DeliveryItemViewModel {
    
    internal typealias completion           = () -> Void
    internal typealias completionWithError  = (Error) -> Void

    var completionWithSuccess   : completion?
    var completionWithNoData    : completion?
    var completionWithError     : completionWithError?
    var failureWithoutError     : completion?
    var handleNextPageLoading   : completion?
    var handleInternetError     : completion?

    //MARK: - Variables
    var allItemArray = [DeliveryItem]()
    var isLoading = false
    var offset = 0
    
    //Create CoredataManager & ApiManager to make it Testable using Mocking
    var apiManager: APIManagerProtocol = APIManager()
    var coreDataManager: CoredataManagerProtocol = CoreDataManager.shared

    //MARK: - Fetch Item from Server
    private func fetchItemFromServer(isRefreshData refresh: Bool) {
        if !CommonClass.shared.isInternetConnected() {
            handleInternetError?()
            //retrn
        }
        if self.allItemArray.isEmpty && !refresh {
            CommonClass.shared.showLoader()
        }
        offset = refresh ? 0 : allItemArray.count
        apiManager.getItemsFromServer(offset: offset, limit: FetchLimit) {[weak self] (item, error) in
            self?.isLoading = false
            if let item = item {
                guard !item.isEmpty else {
                    self?.completionWithNoData?()
                    return
                }
                if refresh {
                    self?.onSuccessRefreshItems(withItems: item)
                } else {
                    self?.onSuccessLoadNewItems(withItems: item, fromDB: false)
                }
            } else if let error = error {
                self?.completionWithError?(error)
            } else {
                self?.failureWithoutError?()
            }
        }
    }
    
    //MARK:- Fetch Item from Local Data Base
    private func fetchItemFromLocalDB() {
        offset = allItemArray.count
        self.coreDataManager.fetchItemFromDatabase(offset: offset) {[weak self] (items, err) in
            if err != nil {
                self?.completionWithError?(err!)
            } else {
                if !items.isEmpty {
                    self?.onSuccessLoadNewItems(withItems: items, fromDB: true)
                } else {
                    self?.fetchItemFromServer(isRefreshData: false)
                }
            }
        }
    }
    
    //MARK:- Handle Refresh Success
    private func onSuccessRefreshItems(withItems items: [DeliveryItem]) {
        allItemArray = items
        self.completionWithSuccess?()
        coreDataManager.deleteItemData {[weak self] (error) in
            if error != nil {
                self?.completionWithError?(error!)
            } else {
                self?.coreDataManager.saveItemToLocalDB(items: items)
            }
        }
    }
    
    //MARK:- Handle Loading New Item Success
    private func onSuccessLoadNewItems(withItems items: [DeliveryItem], fromDB isFromDB: Bool) {
        allItemArray.append(contentsOf: items)
        self.completionWithSuccess?()
        if !isFromDB {
            self.coreDataManager.saveItemToLocalDB(items: items)
        }
    }
}

//MARK: - Extension DeliveryItemViewModel
extension DeliveryItemViewModel: DeliveryItemViewModelProtocol {
    //MARK:- Load Data on Table View
    func loadDataOnTableView() {
        if isLoading {
            return
        }
        self.fetchItemFromLocalDB()
    }
    
    //MARK:- Refresh Table View Data
    func refreshTableViewData() {
        if isLoading {
            return
        }
        self.fetchItemFromServer(isRefreshData: true)
    }
    
    //MARK:- Check Table View Bottom Dragging
    func checkTableViewBottomDrag(_ index: Int) {
        let newIndex = index+1
        if newIndex % FetchLimit == 0 && allItemArray.count <= newIndex {
            self.handleNextPageLoading?()
            self.loadDataOnTableView()
        }
    }
    
    //MARK:- Get Item Detail View Model
    func getItemDetailViewModel(fromIndex index: Int) -> DeliveryDetailViewModel? {
        if self.allItemArray.count > index {
            return DeliveryDetailViewModel.init(withItem: allItemArray[index])
        }
        return nil
    }
}
