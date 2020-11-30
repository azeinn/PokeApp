//
//  AppDelegate.swift
//  PokeApp
//
//  Created by ahmad zen on 27/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
        SVProgressHUD.setMaximumDismissTimeInterval(1)

        let navController = UINavigationController()

        navController.navigationBar.tintColor = UIColor(named: "second")
        navController.navigationBar.barTintColor = UIColor(named: "principal")
        navController.navigationBar.isTranslucent = false

        coordinator = MainCoordinator(navigationController: navController)
        coordinator?.start()

        // create a basic UIWindow and activate it
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
    }

}

