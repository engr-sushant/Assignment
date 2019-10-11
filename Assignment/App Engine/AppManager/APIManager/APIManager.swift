import Foundation
import Alamofire

class APIManager {

    internal typealias WebServiceCompletion = (_ response : DataResponse<Any>) -> Void
    internal typealias GetItemsFromServerCompletion = (_ items : [DeliveryItem]?,_ error: Error?) -> Void
    internal typealias WebServiceFailure = (Error?) -> Void
    
    //MARK:- BASEURL
    let BASEURL: String = "https://mock-api-mobile.dev.lalamove.com/"

    public enum apiType : String {
        
        case fetchAllItems
        
        var description: String {
            switch self {
            case .fetchAllItems     : return "deliveries"
                
            }
        }
    }
    
    //MARK:- Use This Method To Make API Calls
    private class func apiService(url                       : String,
                                  parameter                 : [String: Any],
                                  completion                : @escaping WebServiceCompletion) {
        
        AF.request(url, method: .get, parameters: parameter).responseJSON { (response) in
            completion(response)
        }
    }
}

//MARK: - Extension APIManagerProtocol
extension APIManager: APIManagerProtocol {
    
    //MARK:- Fetch All Delivery Items From Server
    func getItemsFromServer(offset              : Int,
                            limit               : Int,
                            completionBlock     : @escaping GetItemsFromServerCompletion) {
        
        let url = BASEURL + APIManager.apiType.fetchAllItems.description
        let parameters = [keyOffset: offset, keyLimit: limit]
        
        APIManager.apiService(url: url, parameter: parameters) { (data) in
            if let json = data.value as? [[String: Any]] {
                var allItems = [DeliveryItem]()
                for item in json {
                    allItems.append(DeliveryItem.init(withJson: item))
                }
                completionBlock(allItems, nil)
            }
            else {
                completionBlock(nil, data.error ?? nil)
            }
        }
    }
}
