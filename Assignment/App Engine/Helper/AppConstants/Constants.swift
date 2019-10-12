import Foundation
import UIKit

struct ViewRelatedConstants {
    
    // MARK: - App Image Constants
    static let appPlaceholderImage: UIImage    = #imageLiteral(resourceName: "default_placeholder")
    
    // MARK: - View Constraints Constants
    static let paddingConstant: CGFloat        = 10
    static let zeroPaddingConstant: CGFloat    = 0
    static let imageHeight: CGFloat            = 90
    
    // MARK: - Border View Constants
    static let borderWidth: CGFloat            = 2.5
    static let borderColor: UIColor            = .black
    static let mapViewHeight: CGFloat          = 200
}

struct APIQueryConstants {
    
    // MARK: - Get Deliveries Parameters
    static let keyOffset: String   = "offset"
    static let keyLimit: String    = "limit"
    static let fetchLimit          = 20
}

struct CoredataConstants {
    
    // MARK: - Coredata Constants
    static let stackName: String           = "Assignment"
    static let entityNameItem: String      = "EntityItem"
    static let entityNameLocation: String  = "EntityLocation"
}
