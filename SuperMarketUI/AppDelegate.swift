//
//  AppDelegate.swift
//  SuperMarketUI
//
//  Created by Douglas Alexandre Barros Taquary on 19/02/20.
//  Copyright © 2020 Douglas Taquary. All rights reserved.
//

import UIKit
import LLVS
import LLVSCloudKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    lazy var storeCoordinator: StoreCoordinator = {
        LLVS.log.level = .verbose
        let coordinator = try! StoreCoordinator()
        let container = CKContainer(identifier: "iCloud.com.douglastaquary.supermarketui")
        let exchange = CloudKitExchange(with: coordinator.store, storeIdentifier: "MainStore", cloudDatabaseDescription: .privateDatabaseWithCustomZone(container, zoneIdentifier: "MainZone"))
        coordinator.exchange = exchange
        exchange.subscribeForPushNotifications()
        return coordinator
    }()
    
    lazy var dataSource: SupermarketViewModel = {
        SupermarketViewModel(storeCoordinator: storeCoordinator)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let preSyncVersion = storeCoordinator.currentVersion
        dataSource.sync { _ in
            let result: UIBackgroundFetchResult = self.storeCoordinator.currentVersion == preSyncVersion ? .noData : .newData
            completionHandler(result)
        }
    }

}

