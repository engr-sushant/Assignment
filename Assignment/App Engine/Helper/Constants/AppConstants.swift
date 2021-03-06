import Foundation
import UIKit

// MARK: - App Constants
struct AppConstants {
    static let googleAPIKey: String = "AIzaSyC9trrzekwJS2fF4kWHRx99cvbyTDKdfK0"
    static let sharedAppDelegate = UIApplication.shared.delegate as! AppDelegate
    static let kEmptyString = ""
}

// MARK: - View Constraints Constants
struct ViewConstraintConstants {
    static let paddingConstant: CGFloat        = 10
    static let zeroPaddingConstant: CGFloat    = 0
    static let imageHeight: CGFloat            = 90
}

// MARK: - Coredata Constants
struct CoredataConstants {
    static let stackName: String           = "Assignment"
    static let entityNameItem: String      = "EntityItem"
    static let entityNameLocation: String  = "EntityLocation"
}

// MARK: - Border View Constants
struct BorderViewConstants {
    static let borderWidth: CGFloat            = 2.5
    static let borderColor: UIColor            = .black
}

// MARK: - App Default Placeholder Image Constants
struct AppPlaceholderImageConstants {
    static let deliveryItem: UIImage = #imageLiteral(resourceName: "default_placeholder")
}
