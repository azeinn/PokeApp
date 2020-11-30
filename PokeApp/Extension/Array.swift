//
//  Array.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit

extension Array {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Int) -> Element? {
        if index >= 0, index < count {
            return self[index]
        }
        return nil
    }
}
