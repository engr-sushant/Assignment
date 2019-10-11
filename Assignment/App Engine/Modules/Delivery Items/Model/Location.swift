import UIKit

struct Location {

    var latitude: Double?
    var longitude: Double?
    var address: String?
    
    init(withJson json : [String: Any]) {
        if let latitude = json[kLatitude] as? Double {
            self.latitude = latitude
        }
        if let longitude = json[kLongitude] as? Double {
            self.longitude = longitude
        }
        if let address = json[kAddress] as? String {
            self.address = address
        }
    }
    
    //MARK: - Initialize Location with Coredata Model
    init(withDBModel dbModel: EntityLocation) {
        self.latitude = dbModel.latitude
        self.longitude = dbModel.longitude
        self.address = dbModel.address
    }
}
