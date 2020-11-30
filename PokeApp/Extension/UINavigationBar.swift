//
//  UINavigationBar.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func style(backgroundColor: UIColor, titleColor: UIColor = .white) {
        setBackgroundImage(UIImage.from(color: backgroundColor), for: UIBarMetrics.default)
        shadowImage = UIImage()
        barTintColor = backgroundColor
        let font = UIFont(name: "Avenir-Medium", size: 20)!
        titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor, NSAttributedString.Key.font: font]
    }
}
