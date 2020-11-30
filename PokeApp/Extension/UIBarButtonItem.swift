//
//  UIBarButtonItem.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(withImage image: UIImage?, target: Any? = nil, action: Selector? = nil) {
        let but: UIButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
        but.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
        but.backgroundColor = UIColor.clear
        but.setImage(image, for: .normal)

        if let action = action {
            but.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
        }
        but.sizeToFit()

        self.init(customView: but)
    }
}
