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
        guard !isProgressViewAdded else {
            return
        }
        isProgressViewAdded = true
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }
    
    // MARK: - Use this method to hide loader
    func hideLoader() {
        guard isProgressViewAdded else {
            return
        }
        isProgressViewAdded = false
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    // MARK: - Use this method to show toast message
    func showToastWithTitle(messageBody: String, onViewController viewController: UIViewController?) {
        guard let viewController = viewController else {
            return
        }
        viewController.view.makeToast(messageBody)
    }
}
