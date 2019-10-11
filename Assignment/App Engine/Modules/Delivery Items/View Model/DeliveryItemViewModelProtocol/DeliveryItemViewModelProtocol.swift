import Foundation

protocol DeliveryItemViewModelProtocol {
    
    /*
     Use this method to load data on table view.
     **/
    func loadDataOnTableView()
    
    /*
     Use this method to refresh table view data.
     **/
    func refreshTableViewData()
    
    /*
     Use this method to check table view bottom dragging.
     **/
    func checkTableViewBottomDrag(_ index: Int)
    
    /*
     Use this method to get ItemDetailViewModel.
     **/
    func getItemDetailViewModel(fromIndex index: Int) -> DeliveryDetailViewModel?
}
