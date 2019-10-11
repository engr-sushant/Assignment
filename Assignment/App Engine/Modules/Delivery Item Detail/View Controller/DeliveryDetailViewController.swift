import UIKit
import GoogleMaps

class DeliveryDetailViewController: UIViewController {

    //MARK:- UI Elements
    var itemImageView = UIImageView()
    var itemDescriptionLbl = UILabel()
    var borderView = UIView()

    //MARK:- Constants
    let mapZoom: Float = 15.0
    
    //MARK:- Variables
    var itemDetailVM: DeliveryDetailViewModel!
    var mapView = GMSMapView()
    
    //MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupMapView()
        self.setupUIElements()
        self.layoutUIElements()
        self.plotData()
    }
    
    //MARK:- Setup Navigation Bar
    func setupNavigationBar() {
        self.title = LocalizedString.ITEMDETAILVCTITLE
    }
    
    //MARK:- Setup Map View
    func setupMapView() {
        if let location = itemDetailVM.item.location, let lat = location.latitude, let long = location.longitude, let address = location.address {
            let camera = GMSCameraPosition.init(latitude: lat, longitude: long, zoom: mapZoom)
            mapView.camera = camera
            
            //Setup marker on Map View
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
            marker.title = address
            marker.map = mapView
            mapView.selectedMarker = marker
        }
    }
    
    //MARK:- Setup UI Elements
    func setupUIElements() {
        self.view.backgroundColor = .white
        
        //Setup Item Image View
        itemImageView.clipsToBounds = true
        itemImageView.contentMode = UIView.ContentMode.scaleAspectFill
        
        //Setup Description Label
        itemDescriptionLbl.numberOfLines = 0
        itemDescriptionLbl.textAlignment = NSTextAlignment.left
        
        //Setup Border View
        borderView.layer.borderColor = borderColor.cgColor
        borderView.layer.borderWidth = borderWidth
    }
    
    //MARK:- Add Constraints to UI Elements
    func layoutUIElements() {
        self.view.addSubview(mapView)
        self.view.addSubview(borderView)

        //Adding constraint to Map View
        let cornerAnchorForMapView = ConrnerAnchor(top      : (self.topLayoutGuide.bottomAnchor, zeroPaddingConstant),
                                                   bottom   : (borderView.topAnchor, paddingConstant),
                                                   left     : (self.view.leftAnchor, zeroPaddingConstant),
                                                   right    : (self.view.rightAnchor, zeroPaddingConstant)
        )
        mapView.addConstraints(cornerConstraints: cornerAnchorForMapView,
                               centerY  : nil,
                               centerX  : nil,
                               height   : zeroPaddingConstant,
                               width    : zeroPaddingConstant
        )
        
        //Adding constraint to Border View
        let cornerAnchorForBorderView = ConrnerAnchor(top       : (self.mapView.bottomAnchor, paddingConstant),
                                                      bottom    : (self.bottomLayoutGuide.topAnchor, paddingConstant),
                                                      left      : (self.view.leftAnchor, paddingConstant),
                                                      right     : (self.view.rightAnchor, paddingConstant)
        )
        borderView.addConstraints(cornerConstraints: cornerAnchorForBorderView,
                                  centerY   : nil,
                                  centerX   : nil,
                                  height    : zeroPaddingConstant,
                                  width     : zeroPaddingConstant
        )

        borderView.addSubview(itemImageView)
        borderView.addSubview(itemDescriptionLbl)
        
        //Adding constraint to Item Image View
        let cornerConstraintForItemImgView = ConrnerAnchor(top: (nil, zeroPaddingConstant),
                                                           bottom: (nil, zeroPaddingConstant),
                                                           left: (borderView.leftAnchor, paddingConstant),
                                                           right: (nil, zeroPaddingConstant))
        itemImageView.addConstraints(cornerConstraints: cornerConstraintForItemImgView,
                                     centerY    : itemDescriptionLbl.centerYAnchor,
                                     centerX    : nil,
                                     height     : imageHeight,
                                     width      : imageHeight
        )
        
        //Adding constraint to Item Description Label
        let cornerConstraintForDescriptionLbl = ConrnerAnchor(top: (borderView.topAnchor, paddingConstant),
                                                              bottom: (borderView.bottomAnchor, paddingConstant),
                                                              left: (itemImageView.rightAnchor, paddingConstant),
                                                              right: (borderView.rightAnchor, paddingConstant)
        )
        itemDescriptionLbl.addConstraints(cornerConstraints: cornerConstraintForDescriptionLbl,
                                          centerY   : nil,
                                          centerX   : nil,
                                          height    : zeroPaddingConstant,
                                          width     : zeroPaddingConstant
        )
        itemDescriptionLbl.heightAnchor.constraint(greaterThanOrEqualToConstant: imageHeight).isActive = true
    }
    
    //MARK:- Plot Data
    func plotData() {
        if let url = itemDetailVM.item.imageUrl {
            self.itemImageView.sd_setImage(with: URL.init(string: url), placeholderImage: AppPlaceholderImage)
        } else {
            self.itemImageView.image = AppPlaceholderImage
        }
        
        guard let desc = itemDetailVM.item.itemDescription else {
            self.itemDescriptionLbl.text = kEmptyString
            return
        }
        self.itemDescriptionLbl.text = desc
        guard let locationAddress = itemDetailVM.item.location?.address else {
            return
        }
        self.itemDescriptionLbl.text = desc + LocalizedString.AT + locationAddress
    }
}
