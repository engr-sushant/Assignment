import UIKit
import GoogleMaps

class DeliveryDetailViewController: UIViewController {

    // MARK: - UI Elements
    var itemImageView = UIImageView()
    var itemDescriptionLbl = UILabel()
    var borderView = UIView()

    // MARK: - Constants
    let mapZoom: Float = 15.0
    
    // MARK: - Variables
    var itemDetailVM: DeliveryDetailViewModel!
    var mapView = GMSMapView()
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupMapView()
        self.setupUIElements()
        self.layoutUIElements()
        self.plotData()
    }
    
    // MARK: - Setup Navigation Bar
    func setupNavigationBar() {
        self.title = LocalizedString.DELIVERYDETAILVCTITLE
    }
    
    // MARK: - Setup Map View
    func setupMapView() {
        if let location = itemDetailVM.item.location, let lat = location.lat, let long = location.lng, let address = location.address {
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
    
    // MARK: - Setup UI Elements
    func setupUIElements() {
        self.view.backgroundColor = .white
        
        //Setup Item Image View
        itemImageView.clipsToBounds = true
        itemImageView.contentMode = UIView.ContentMode.scaleAspectFill
        
        //Setup Description Label
        itemDescriptionLbl.numberOfLines = 0
        itemDescriptionLbl.textAlignment = NSTextAlignment.left
        
        //Setup Border View
        borderView.layer.borderColor = ViewRelatedConstants.borderColor.cgColor
        borderView.layer.borderWidth = ViewRelatedConstants.borderWidth
    }
    
    // MARK: - Add Constraints to UI Elements
    func layoutUIElements() {
        self.view.addSubview(mapView)
        self.view.addSubview(borderView)

        //Adding constraint to Map View
        let cornerAnchorForMapView = ConrnerAnchor(top      : (self.topLayoutGuide.bottomAnchor, ViewRelatedConstants.zeroPaddingConstant),
                                                   bottom   : (borderView.topAnchor, ViewRelatedConstants.paddingConstant),
                                                   left     : (self.view.leftAnchor, ViewRelatedConstants.zeroPaddingConstant),
                                                   right    : (self.view.rightAnchor, ViewRelatedConstants.zeroPaddingConstant)
        )
        mapView.addConstraints(cornerConstraints: cornerAnchorForMapView,
                               centerY  : nil,
                               centerX  : nil,
                               height   : ViewRelatedConstants.zeroPaddingConstant,
                               width    : ViewRelatedConstants.zeroPaddingConstant
        )
        
        //Adding constraint to Border View
        let cornerAnchorForBorderView = ConrnerAnchor(top       : (self.mapView.bottomAnchor, ViewRelatedConstants.paddingConstant),
                                                      bottom    : (self.bottomLayoutGuide.topAnchor, ViewRelatedConstants.paddingConstant),
                                                      left      : (self.view.leftAnchor, ViewRelatedConstants.paddingConstant),
                                                      right     : (self.view.rightAnchor, ViewRelatedConstants.paddingConstant)
        )
        borderView.addConstraints(cornerConstraints: cornerAnchorForBorderView,
                                  centerY   : nil,
                                  centerX   : nil,
                                  height    : ViewRelatedConstants.zeroPaddingConstant,
                                  width     : ViewRelatedConstants.zeroPaddingConstant
        )

        borderView.addSubview(itemImageView)
        borderView.addSubview(itemDescriptionLbl)
        
        //Adding constraint to Item Image View
        let cornerConstraintForItemImgView = ConrnerAnchor(top: (nil, ViewRelatedConstants.zeroPaddingConstant),
                                                           bottom: (nil, ViewRelatedConstants.zeroPaddingConstant),
                                                           left: (borderView.leftAnchor, ViewRelatedConstants.paddingConstant),
                                                           right: (nil, ViewRelatedConstants.zeroPaddingConstant))
        itemImageView.addConstraints(cornerConstraints: cornerConstraintForItemImgView,
                                     centerY    : itemDescriptionLbl.centerYAnchor,
                                     centerX    : nil,
                                     height     : ViewRelatedConstants.imageHeight,
                                     width      : ViewRelatedConstants.imageHeight
        )
        
        //Adding constraint to Item Description Label
        let cornerConstraintForDescriptionLbl = ConrnerAnchor(top: (borderView.topAnchor, ViewRelatedConstants.paddingConstant),
                                                              bottom: (borderView.bottomAnchor, ViewRelatedConstants.paddingConstant),
                                                              left: (itemImageView.rightAnchor, ViewRelatedConstants.paddingConstant),
                                                              right: (borderView.rightAnchor, ViewRelatedConstants.paddingConstant)
        )
        itemDescriptionLbl.addConstraints(cornerConstraints: cornerConstraintForDescriptionLbl,
                                          centerY   : nil,
                                          centerX   : nil,
                                          height    : ViewRelatedConstants.zeroPaddingConstant,
                                          width     : ViewRelatedConstants.zeroPaddingConstant
        )
        itemDescriptionLbl.heightAnchor.constraint(greaterThanOrEqualToConstant: ViewRelatedConstants.imageHeight).isActive = true
    }
    
    // MARK: - Plot Data
    func plotData() {
        self.itemImageView.sd_setImage(with: URL(string: itemDetailVM.item.imageUrl), placeholderImage: ViewRelatedConstants.appPlaceholderImage)

        guard let desc = itemDetailVM.item.description else {
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
