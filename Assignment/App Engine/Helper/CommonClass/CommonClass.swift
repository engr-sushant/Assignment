import Foundation
import SVProgressHUD
import Alamofire

class CommonClass: NSObject {
    
    static let shared: CommonClass = {
        return CommonClass()
    }()
    
    var isProgressViewAdded = false
    
    // MARK: - Use this method to show alert
    func showAlertWithTitle(messageBody: String, okBlock: @escaping (() -> Void)) {
        let alertVC = UIAlertController(title: LocalizedString.APPNAME, message: messageBody, preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizedString.OK, style: .default) { (_) in
            okBlock()
        }
        alertVC.addAction(okAction)
        sharedAppDelegate.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
    }
        
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
}
