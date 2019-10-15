import UIKit

struct DeliveryItem: Codable {
    
    var id: Int?
    var description: String?
    var imageUrl: String?
    var location: Location?
    
    init(id: Int?, itemDescription: String?, imageUrl: String?, location: Location?) {
        self.id = id
        self.description = itemDescription
        self.imageUrl = imageUrl
        self.location = location
    }
}
