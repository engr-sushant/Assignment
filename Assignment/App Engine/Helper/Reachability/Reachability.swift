import Foundation
import Alamofire

class Reachability: ReachabilityProtocol {
    
    // MARK: - Check internet connection
    func isInternetConnected() -> Bool {
        guard let manager = NetworkReachabilityManager() else {
            return false
        }
        return manager.isReachable
    }
}
