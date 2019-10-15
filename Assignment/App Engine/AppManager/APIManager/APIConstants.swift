import Foundation

typealias GetDeliveriesFromServerCompletion = ((Result<[DeliveryItem], Error>) -> Void)

struct APIConstants {
    // MARK: - Base URL
    static let baseURL: String = "https://mock-api-mobile.dev.lalamove.com/"

    public enum APIName: String {
        
        case deliveries
        
        var description: String {
            switch self {
            case .deliveries     : return "deliveries"
            }
        }
    }
}

// MARK: - API Query Constant
struct APIQueryConstant {
    static let keyOffset: String   = "offset"
    static let keyLimit: String    = "limit"
    static let fetchLimit          = 20
}
