import UIKit
import SDWebImage

class DeliveryItemTableViewCell: UITableViewCell {
    
    //MARK:- UI Elements
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
    
    //MARK:- Setup UI Elements
    func setupUI() {
        //Setup Border View
        borderView.layer.borderWidth = borderWidth
        borderView.layer.borderColor = borderColor.cgColor

        //Setup Item Image View
        cellImageView.clipsToBounds = true
        cellImageView.contentMode = .scaleAspectFill

        //Setup Description Label
        descriptionLbl.textAlignment = NSTextAlignment.left
        descriptionLbl.textColor = UIColor.black
        descriptionLbl.numberOfLines = 0
    }
    
    //MARK:- Add Constraints to UI Elements
    func layoutUIElements() {
        self.selectionStyle = .none
        addSubview(borderView)
        
        //Adding constraint to Border View
        let constraintForBorderView = ConrnerAnchor(top     : (topAnchor, paddingConstant),
                                                    bottom  : (bottomAnchor, paddingConstant),
                                                    left    : (leftAnchor, paddingConstant),
                                                    right   : (rightAnchor, paddingConstant)
        )
        borderView.addConstraints(cornerConstraints: constraintForBorderView,
                                  centerY   : nil,
                                  centerX   : nil,
                                  height    : zeroPaddingConstant,
                                  width     : zeroPaddingConstant
        )
        
        borderView.addSubview(cellImageView)
        borderView.addSubview(descriptionLbl)
        
        //Adding constraint to Item Description Label
        let constraintForDescriptionLbl = ConrnerAnchor(top     : (borderView.topAnchor, paddingConstant),
                                                        bottom  : (borderView.bottomAnchor, paddingConstant),
                                                        left    : (cellImageView.rightAnchor, paddingConstant),
                                                        right   : (borderView.rightAnchor, paddingConstant)
        )
        descriptionLbl.addConstraints(cornerConstraints: constraintForDescriptionLbl,
                                      centerY   : nil,
                                      centerX   : nil,
                                      height    : zeroPaddingConstant,
                                      width     : zeroPaddingConstant
        )
        descriptionLbl.heightAnchor.constraint(greaterThanOrEqualToConstant: imageHeight).isActive = true
        
        //Adding constraint to Item Image View
        let constraintForCellImageView = ConrnerAnchor(top      : (nil, zeroPaddingConstant),
                                                       bottom   : (nil, zeroPaddingConstant),
                                                       left     : (borderView.leftAnchor, paddingConstant),
                                                       right    : (nil, zeroPaddingConstant)
        )
        cellImageView.addConstraints(cornerConstraints: constraintForCellImageView,
                                     centerY    : descriptionLbl.centerYAnchor,
                                     centerX    : nil,
                                     height     : imageHeight,
                                     width      : imageHeight
        )
    }
    
    //MARK:- Plot Data on Cell
    func plotDataOnCell(withCellItem item: DeliveryItem) {
        
        if let url = item.imageUrl {
            self.cellImageView.sd_setImage(with: URL.init(string: url), placeholderImage: AppPlaceholderImage)
        } else {
            self.cellImageView.image = AppPlaceholderImage
        }
        
        guard let desc = item.itemDescription else {
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
