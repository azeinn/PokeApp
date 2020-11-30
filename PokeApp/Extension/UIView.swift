//
//  UIView.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        var cornArr = CACornerMask()

        if corners.contains(.topRight) {
            cornArr.insert(.layerMaxXMinYCorner)
        }

        if corners.contains(.topLeft) {
            cornArr.insert(.layerMinXMinYCorner)
        }

        if corners.contains(.bottomLeft) {
            cornArr.insert(.layerMinXMaxYCorner)
        }

        if corners.contains(.bottomRight) {
            cornArr.insert(.layerMaxXMaxYCorner)
        }

        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = cornArr
    }
}
