import UIKit
import GoogleMaps

struct DeliveryDetailConstatnt {
    static let mapZoom: Float = 15.0
    static let zeroNumberOfLine: Int = 0
}

class DeliveryDetailViewController: UIViewController {

    // MARK: - UI Elements
    var itemImageView = UIImageView()
    var itemDescriptionLbl = UILabel()
    var borderView = UIView()
    
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
            let camera = GMSCameraPosition.init(latitude: lat, longitude: long, zoom: DeliveryDetailConstatnt.mapZoom)
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
        itemDescriptionLbl.numberOfLines = DeliveryDetailConstatnt.zeroNumberOfLine
        itemDescriptionLbl.textAlignment = NSTextAlignment.left
        
        //Setup Border View
        borderView.layer.borderColor = BorderViewConstants.borderColor.cgColor
        borderView.layer.borderWidth = BorderViewConstants.borderWidth
    }
    
    // MARK: - Plot Data
    func plotData() {
        if let url = itemDetailVM.item.imageUrl {
            self.itemImageView.sd_setImage(with: URL(string: url), placeholderImage: AppPlaceholderImageConstants.deliveryItem)
        } else {
            self.itemImageView.image = AppPlaceholderImageConstants.deliveryItem
        }
        
        guard let desc = itemDetailVM.item.description else {
            self.itemDescriptionLbl.text = AppConstants.kEmptyString
            return
        }
        self.itemDescriptionLbl.text = desc
        guard let locationAddress = itemDetailVM.item.location?.address else {
            return
        }
        self.itemDescriptionLbl.text = desc + LocalizedString.AT + locationAddress
    }
    
    // MARK: - Add Constraints to UI Elements
    func layoutUIElements() {
        self.view.addSubview(mapView)
        self.view.addSubview(borderView)

        //Adding constraint to Map View
        let cornerAnchorForMapView = ConrnerAnchor(top      : (self.topLayoutGuide.bottomAnchor, ViewConstraintConstants.zeroPaddingConstant),
                                                   bottom   : (borderView.topAnchor, ViewConstraintConstants.paddingConstant),
                                                   left     : (self.view.leftAnchor, ViewConstraintConstants.zeroPaddingConstant),
                                                   right    : (self.view.rightAnchor, ViewConstraintConstants.zeroPaddingConstant)
        )
        mapView.addConstraints(cornerConstraints: cornerAnchorForMapView,
                               centerY  : nil,
                               centerX  : nil,
                               height   : ViewConstraintConstants.zeroPaddingConstant,
                               width    : ViewConstraintConstants.zeroPaddingConstant
        )
        
        //Adding constraint to Border View
        let cornerAnchorForBorderView = ConrnerAnchor(top       : (self.mapView.bottomAnchor, ViewConstraintConstants.paddingConstant),
                                                      bottom    : (self.bottomLayoutGuide.topAnchor, ViewConstraintConstants.paddingConstant),
                                                      left      : (self.view.leftAnchor, ViewConstraintConstants.paddingConstant),
                                                      right     : (self.view.rightAnchor, ViewConstraintConstants.paddingConstant)
        )
        borderView.addConstraints(cornerConstraints: cornerAnchorForBorderView,
                                  centerY   : nil,
                                  centerX   : nil,
                                  height    : ViewConstraintConstants.zeroPaddingConstant,
                                  width     : ViewConstraintConstants.zeroPaddingConstant
        )

        borderView.addSubview(itemImageView)
        borderView.addSubview(itemDescriptionLbl)
        
        //Adding constraint to Item Image View
        let cornerConstraintForItemImgView = ConrnerAnchor(top: (nil, ViewConstraintConstants.zeroPaddingConstant),
                                                           bottom: (nil, ViewConstraintConstants.zeroPaddingConstant),
                                                           left: (borderView.leftAnchor, ViewConstraintConstants.paddingConstant),
                                                           right: (nil, ViewConstraintConstants.zeroPaddingConstant))
        itemImageView.addConstraints(cornerConstraints: cornerConstraintForItemImgView,
                                     centerY    : itemDescriptionLbl.centerYAnchor,
                                     centerX    : nil,
                                     height     : ViewConstraintConstants.imageHeight,
                                     width      : ViewConstraintConstants.imageHeight
        )
        
        //Adding constraint to Item Description Label
        let cornerConstraintForDescriptionLbl = ConrnerAnchor(top: (borderView.topAnchor, ViewConstraintConstants.paddingConstant),
                                                              bottom: (borderView.bottomAnchor, ViewConstraintConstants.paddingConstant),
                                                              left: (itemImageView.rightAnchor, ViewConstraintConstants.paddingConstant),
                                                              right: (borderView.rightAnchor, ViewConstraintConstants.paddingConstant)
        )
        itemDescriptionLbl.addConstraints(cornerConstraints: cornerConstraintForDescriptionLbl,
                                          centerY   : nil,
                                          centerX   : nil,
                                          height    : ViewConstraintConstants.zeroPaddingConstant,
                                          width     : ViewConstraintConstants.zeroPaddingConstant
        )
        itemDescriptionLbl.heightAnchor.constraint(greaterThanOrEqualToConstant: ViewConstraintConstants.imageHeight).isActive = true
    }
}
