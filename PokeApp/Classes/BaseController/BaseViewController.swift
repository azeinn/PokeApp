//
//  BaseViewController.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {
    enum NavigationBarStyle {
        case transparent
        case white
        case custom(color: UIColor)
    }
}

class BaseViewController: UIViewController, Storyboarded {
    var notificationManager = NotificationManager()
    var disposeBag: DisposeBag = DisposeBag() // RX
    var navigationBarStyle: UIViewController.NavigationBarStyle = .white

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setNavigationBarStyle()
    }

    func setNavigationBarStyle() {
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        navigationBar.barStyle = .default

        switch navigationBarStyle {
        case .transparent:
            navigationBar.style(backgroundColor: .clear, titleColor: .black)
            navigationBar.isTranslucent = true
        case .white:
            navigationBar.setBackgroundImage(UIImage(named: "Background"), for: .default)
            navigationBar.isTranslucent = false
        case let .custom(color):
            navigationBar.style(backgroundColor: color, titleColor: .white)
            navigationBar.isTranslucent = false
        }
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        notificationManager.deregisterAll()
        super.dismiss(animated: flag, completion: completion)
    }

    deinit {
        disposeBag = DisposeBag()
        notificationManager.deregisterAll()
        NotificationCenter.default.removeObserver(self)
        print("*********Deallocating \(Mirror(reflecting: self).subjectType) ****************")
    }
}
