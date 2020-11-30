//
//  NotificationManager.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import Foundation
import UIKit

open class NotificationManager {
    private var observerTokens: [Any] = []

    public init() {}

    deinit {
        deregisterAll()
    }

    open func deregisterAll() {
        for token in observerTokens {
            NotificationCenter.default.removeObserver(token)
        }

        observerTokens = []
    }

    open func addObserver(forName name: NSNotification.Name, action: @escaping ((Notification) -> Void)) {
        let newToken = NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { note in
            action(note)
        }

        observerTokens.append(newToken)
    }

    open func addObserver(forNameString name: String, forObject object: Any? = nil, action: @escaping ((Notification) -> Void)) {
        let newToken = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: name), object: object, queue: nil) { note in
            action(note)
        }

        observerTokens.append(newToken)
    }
}

public struct NotificationGroup {
    let entries: [String]

    init(_ newEntries: String...) {
        entries = newEntries
    }
}

public extension NotificationManager {
    func addGroupObserver(_ group: NotificationGroup, action: @escaping ((Notification) -> Void)) {
        for name in group.entries {
            addObserver(forNameString: name, action: action)
        }
    }
}

public extension Notification {
    var keyboardHeight: CGFloat {
        if let keyboardSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            return keyboardSize.height
        }
        return 0
    }

    var keyboardAnimationDuration: Double {
        if let animationDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            return animationDuration
        }
        return 0
    }

    var keyboardAnimationOptions: UIView.AnimationOptions {
        if let options = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int {
            return UIView.AnimationOptions(rawValue: UInt(options << 16))
        }
        return UIView.AnimationOptions.curveEaseIn
    }

    var keyboardAnimationType: UIView.AnimationOptions {
        return keyboardAnimationOptions
    }
}

public extension NotificationManager {
    func postNotification(withName aName: Notification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: aName, object: object, userInfo: userInfo)
    }

    func postNotification(withNameString aName: String, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: aName), object: object, userInfo: userInfo)
    }
}
