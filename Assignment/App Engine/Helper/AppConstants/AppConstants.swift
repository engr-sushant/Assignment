import Foundation
import UIKit

//MARK:- APP Constant
let APPNAME = "Assignment"
let SharedAppDelegate = UIApplication.shared.delegate as! AppDelegate

//MARK:- Google API key
let GoogleAPIKey: String = "AIzaSyC9trrzekwJS2fF4kWHRx99cvbyTDKdfK0"

//MARK: - Default Placeholder Image
let AppPlaceholderImage: UIImage = #imageLiteral(resourceName: "default_placeholder")

//MARK: - Coredata Related
let StackName: String           = "Assignment"
let EntityNameItem: String      = "EntityItem"
let EntityNameLocation: String  = "EntityLocation"

//MARK:- API Query String Parameters
let keyOffset: String   = "offset"
let keyLimit: String    = "limit"
let FetchLimit          = 20

//MARK:- Constant Parameter
let imageHeight: CGFloat    = 90
let paddingConstant: CGFloat = 10
let zeroPaddingConstant: CGFloat = 0

let borderWidth: CGFloat    = 2.5
let borderColor: UIColor    = .black
let mapViewHeight: CGFloat  = 200

//MARK:- Progress View Related
let progressViewRadius: CGFloat         = 20
let progressViewStrokeWidth: CGFloat    = 1
let progressViewStrokeAlpha: CGFloat    = 0.5

//MARK:- Item Model Keys
let kEmptyString    = ""
let kId             = "id"
let kDescription    = "description"
let kImageUrl       = "imageUrl"
let kLocation       = "location"

//MARK:- Location Model Keys
let kLatitude   = "lat"
let kLongitude  = "lng"
let kAddress    = "address"
