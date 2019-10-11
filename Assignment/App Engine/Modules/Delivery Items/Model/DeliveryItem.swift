import UIKit

struct DeliveryItem {
    
    var id: Int?
    var itemDescription: String?
    var imageUrl: String?
    var location: Location?
    
    init(withJson json : [String: Any]) {
        if let id = json[kId] as? Int {
            self.id = id
        }
        if let itemDescription = json[kDescription] as? String {
            self.itemDescription = itemDescription
        }
        if let imageUrl = json[kImageUrl] as? String {
            self.imageUrl = imageUrl
        }
        if let location = json[kLocation] as? [String: Any] {
            self.location = Location.init(withJson: location)
        }
    }
    
    //MARK: - Initialize Item with Coredata Model
    init(withDBModel dbModel: EntityItem) {
        self.id = Int(dbModel.id)
        self.itemDescription = dbModel.itemDescription
        self.imageUrl = dbModel.imageUrl
        self.location = Location.init(withDBModel: dbModel.location!)
    }
}
