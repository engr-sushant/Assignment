import UIKit
import SDWebImage

class DeliveryItemCell: UITableViewCell {
    
    // MARK: - UI Elements
    var borderView = UIView()
    var cellImageView = UIImageView()
    var descriptionLbl = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        self.layoutUIElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup UI Elements
    func setupUI() {
        //Setup Border View
        borderView.layer.borderWidth = ViewRelatedConstants.borderWidth
        borderView.layer.borderColor = ViewRelatedConstants.borderColor.cgColor

        //Setup Item Image View
        cellImageView.clipsToBounds = true
        cellImageView.contentMode = .scaleAspectFill

        //Setup Description Label
        descriptionLbl.textAlignment = NSTextAlignment.left
        descriptionLbl.textColor = UIColor.black
        descriptionLbl.numberOfLines = 0
    }
    
    // MARK: - Add Constraints To UI Elements
    func layoutUIElements() {
        self.selectionStyle = .none
        addSubview(borderView)
        
        //Adding constraint to Border View
        let constraintForBorderView = ConrnerAnchor(top     : (topAnchor, ViewRelatedConstants.paddingConstant),
                                                    bottom  : (bottomAnchor, ViewRelatedConstants.paddingConstant),
                                                    left    : (leftAnchor, ViewRelatedConstants.paddingConstant),
                                                    right   : (rightAnchor, ViewRelatedConstants.paddingConstant)
        )
        borderView.addConstraints(cornerConstraints: constraintForBorderView,
                                  centerY   : nil,
                                  centerX   : nil,
                                  height    : ViewRelatedConstants.zeroPaddingConstant,
                                  width     : ViewRelatedConstants.zeroPaddingConstant
        )
        
        borderView.addSubview(cellImageView)
        borderView.addSubview(descriptionLbl)
        
        //Adding constraint to Item Description Label
        let constraintForDescriptionLbl = ConrnerAnchor(top     : (borderView.topAnchor, ViewRelatedConstants.paddingConstant),
                                                        bottom  : (borderView.bottomAnchor, ViewRelatedConstants.paddingConstant),
                                                        left    : (cellImageView.rightAnchor, ViewRelatedConstants.paddingConstant),
                                                        right   : (borderView.rightAnchor, ViewRelatedConstants.paddingConstant)
        )
        descriptionLbl.addConstraints(cornerConstraints: constraintForDescriptionLbl,
                                      centerY   : nil,
                                      centerX   : nil,
                                      height    : ViewRelatedConstants.zeroPaddingConstant,
                                      width     : ViewRelatedConstants.zeroPaddingConstant
        )
        descriptionLbl.heightAnchor.constraint(greaterThanOrEqualToConstant: ViewRelatedConstants.imageHeight).isActive = true
        
        //Adding constraint to Item Image View
        let constraintForCellImageView = ConrnerAnchor(top      : (nil, ViewRelatedConstants.zeroPaddingConstant),
                                                       bottom   : (nil, ViewRelatedConstants.zeroPaddingConstant),
                                                       left     : (borderView.leftAnchor, ViewRelatedConstants.paddingConstant),
                                                       right    : (nil, ViewRelatedConstants.zeroPaddingConstant)
        )
        cellImageView.addConstraints(cornerConstraints: constraintForCellImageView,
                                     centerY    : descriptionLbl.centerYAnchor,
                                     centerX    : nil,
                                     height     : ViewRelatedConstants.imageHeight,
                                     width      : ViewRelatedConstants.imageHeight
        )
    }
    
    // MARK: - Plot Data On Cell
    func plotDataOnCell(withCellItem item: DeliveryItem) {
        
        self.cellImageView.sd_setImage(with: URL(string: item.imageUrl), placeholderImage: ViewRelatedConstants.appPlaceholderImage)
        
        guard let desc = item.description else {
            self.descriptionLbl.text = kEmptyString
            return
        }
        self.descriptionLbl.text = desc
        guard let locationAddress = item.location?.address else {
            return
        }
        self.descriptionLbl.text = desc + LocalizedString.AT + locationAddress
    }
}
