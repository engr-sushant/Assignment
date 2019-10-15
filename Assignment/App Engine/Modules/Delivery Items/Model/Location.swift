import UIKit

struct Location: Codable {

    var lat: Double?
    var lng: Double?
    var address: String?
    
    init(latitude: Double?, longitude: Double?, address: String?) {
        self.lat = latitude
        self.lng = longitude
        self.address = address
    }
}
