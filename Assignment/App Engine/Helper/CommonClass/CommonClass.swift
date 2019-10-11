import Foundation
import MaterialComponents.MaterialActivityIndicator
import Alamofire

class CommonClass: NSObject {
    
    static let shared: CommonClass = {
        return CommonClass()
    }()
    
    var progressView: MDCActivityIndicator!
    var isProgressViewAdded = false

    // MARK: - Use this method to check internet connection
    func isInternetConnected() -> Bool {
        var isInternetConnected = false
        if let manager = NetworkReachabilityManager() {
            isInternetConnected = manager.isReachable
        }
        return isInternetConnected
    }
    
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
            self.progressView = MDCActivityIndicator()
            self.progressView.radius = ViewRelatedConstants.progressViewRadius
            self.progressView.strokeWidth = ViewRelatedConstants.progressViewStrokeWidth
            self.progressView.alpha = ViewRelatedConstants.progressViewStrokeWidth
            if let backgroundView = sharedAppDelegate.window?.rootViewController?.view {
                self.progressView.center = backgroundView.center
            }
            self.progressView.startAnimating()
        }
    }
    
    // MARK: - Use this method to hide loader
    func hideLoader() {
        if !isProgressViewAdded {
            return
        }
        isProgressViewAdded = false
        if progressView == nil {
            return
        }
        DispatchQueue.main.async {
            self.progressView.stopAnimating()
            self.progressView.removeFromSuperview()
        }
    }
}
