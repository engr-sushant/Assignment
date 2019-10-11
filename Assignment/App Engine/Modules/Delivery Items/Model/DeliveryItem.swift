import UIKit

//MARK:- DeliveryItem Model Keys
let kEmptyString    = ""
let kId             = "id"
let kDescription    = "description"
let kImageUrl       = "imageUrl"
let kLocation       = "location"

struct DeliveryItem: Codable {
    
    var id: Int
    var description: String?
    var imageUrl: String
    var location: Location?
    
    init(id: Int, itemDescription: String?, imageUrl: String, location: Location?) {
        self.id = id
        self.description = itemDescription
        self.imageUrl = imageUrl
        self.location = location
    }
}
