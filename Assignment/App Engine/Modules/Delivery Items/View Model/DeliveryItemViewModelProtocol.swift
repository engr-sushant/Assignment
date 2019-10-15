import Foundation
import UIKit

protocol DeliveryItemViewModelProtocol {
    
    /*
     Use this method to load data.
     **/
    func loadData(withLoader loaderType: ProgressLoaderType)
    
    /*
     Use this method to refresh data.
     **/
    func refreshData(withLoader loaderType: ProgressLoaderType)
    
    /*
     Use this method to check bottom dragging.
     **/
    func checkBottomDragging(tblOffset: CGFloat, maxHght: CGFloat)
    
    /*
     Use this method to get DeliveryDetailViewModel.
     **/
    func getDeliveryDetailViewModel(fromIndex index: Int) -> DeliveryDetailViewModel?
}
