import Foundation
import UIKit

struct ViewRelatedConstants {
    
    // MARK: - View Related
    static let appPlaceholderImage: UIImage    = #imageLiteral(resourceName: "default_placeholder")
    static let imageHeight: CGFloat            = 90
    static let paddingConstant: CGFloat        = 10
    static let zeroPaddingConstant: CGFloat    = 0
    static let borderWidth: CGFloat            = 2.5
    static let borderColor: UIColor            = .black
    static let mapViewHeight: CGFloat          = 200
    
    // MARK: - Progress View Related
    static let progressViewRadius: CGFloat     = 20
    static let progressViewStrokeWidth: CGFloat = 1
    static let progressViewStrokeAlpha: CGFloat = 0.5
}

struct APIQueryConstants {
    
    // MARK: - API Query String Parameters
    static let keyOffset: String   = "offset"
    static let keyLimit: String    = "limit"
    static let fetchLimit          = 20
}

struct CoredataConstants {
    
    // MARK: - Coredata Related
    static let stackName: String           = "Assignment"
    static let entityNameItem: String      = "EntityItem"
    static let entityNameLocation: String  = "EntityLocation"
}
