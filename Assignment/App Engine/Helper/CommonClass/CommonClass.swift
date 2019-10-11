import Foundation
import MaterialComponents.MaterialActivityIndicator
import Alamofire

class CommonClass: NSObject {
    
    static let shared: CommonClass = {
        return CommonClass()
    }()
    
    var progressView: MDCActivityIndicator!
    var isProgressViewAdded = false

    //MARK:- Use this method to Check Internet Connection
    func isInternetConnected() -> Bool {
        var isInternetConnected = false
        if let manager = NetworkReachabilityManager() {
            isInternetConnected = manager.isReachable
        }
        return isInternetConnected
    }
    
    //MARK:- Use this method to Show Alert
    func showAlertWithTitle(messageBody: String, showRetry:Bool, okBlock: @escaping (() -> Void), retryBlock: @escaping (() -> Void)) {
        let alertVC = UIAlertController(title: LocalizedString.APPNAME, message: messageBody, preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizedString.OK, style: .default) { (_) in
            okBlock()
        }
        let retryAction = UIAlertAction(title: LocalizedString.RETRY, style: .default) { (_) in
            retryBlock()
        }
        alertVC.addAction(okAction)
        if showRetry {
            alertVC.addAction(retryAction)
        }
        SharedAppDelegate.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
    }
        
    //MARK:- Use this method to Show Loader
    func showLoader() {
        if isProgressViewAdded {
           return
        }
        isProgressViewAdded = true
        DispatchQueue.main.async {
            self.progressView = MDCActivityIndicator()
            self.progressView.radius = progressViewRadius
            self.progressView.strokeWidth = progressViewStrokeWidth
            self.progressView.alpha = progressViewStrokeWidth
            if let backgroundView = SharedAppDelegate.window?.rootViewController?.view {
                self.progressView.center = backgroundView.center
            }
            self.progressView.startAnimating()
        }
    }
    
    //MARK:- Use this method to Hide Loader
    func hideLoader() {
        if isProgressViewAdded {
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
