import Foundation

// MARK: - BASEURL
let BASEURL: String = "https://mock-api-mobile.dev.lalamove.com/"

// MARK: - Get Deliveries Parameters
let keyOffset: String   = "offset"
let keyLimit: String    = "limit"
let fetchLimit          = 20

typealias GetDeliveriesFromServerCompletion = ((Result<[DeliveryItem], Error>) -> Void)

struct APIConstants {
    
    public enum APIName : String {
        
        case deliveries
        
        var description: String {
            switch self {
            case .deliveries     : return "deliveries"
            }
        }
    }
}
