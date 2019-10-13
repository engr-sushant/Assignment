import Foundation
import SVProgressHUD
import Toast_Swift

class CommonClass: NSObject {
    
    static let shared: CommonClass = {
        return CommonClass()
    }()
    
    var isProgressViewAdded = false
    
    // MARK: - Use this method to show loader
    func showLoader() {
        if isProgressViewAdded {
           return
        }
        isProgressViewAdded = true
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }
    
    // MARK: - Use this method to hide loader
    func hideLoader() {
        if !isProgressViewAdded {
            return
        }
        isProgressViewAdded = false
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    // MARK: - Use this method to show toast message
    func showToastWithTitle(messageBody: String, onViewController vc: UIViewController?) {
        guard let vc = vc else {
            return
        }
        vc.view.makeToast(messageBody)
    }
}
