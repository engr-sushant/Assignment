import Foundation
import UIKit

typealias VerticalPadding = (NSLayoutYAxisAnchor?, CGFloat)
typealias HorizontalPadding = (NSLayoutXAxisAnchor?, CGFloat)
typealias ConrnerAnchor = (top: VerticalPadding, bottom: VerticalPadding, left: HorizontalPadding, right: HorizontalPadding)

extension UIView {
    func addConstraints(cornerConstraints: ConrnerAnchor, centerY: NSLayoutYAxisAnchor?, centerX: NSLayoutXAxisAnchor?, height: CGFloat, width: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        addCornerConstraints(constraints: cornerConstraints)
        if let centerY = centerY {
            self.centerYAnchor.constraint(equalTo: centerY, constant: 0).isActive = true
        }
        if let centerX = centerX {
            self.centerXAnchor.constraint(equalTo: centerX, constant: 0).isActive = true
        }
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    func addCornerConstraints(constraints: ConrnerAnchor) {
        if let top = (constraints.0).0 {
            self.topAnchor.constraint(equalTo: top, constant: (constraints.0).1).isActive = true
        }
        if let bottom = (constraints.1).0 {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -(constraints.1).1).isActive = true
        }
        if let left = (constraints.2).0 {
            self.leftAnchor.constraint(equalTo: left, constant: (constraints.2).1).isActive = true
        }
        if let right = (constraints.3).0 {
            self.rightAnchor.constraint(equalTo: right, constant: -(constraints.3).1).isActive = true
        }
    }
}
