//
//  AppDelegate.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 30.10.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureLayoutAppearance()
        configureSettings()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Layout customization
    
    func configureLayoutAppearance() {
        UIApplication.shared.statusBarStyle = .lightContent
        //UINavigationBar.appearance().backIndicatorImage = UIImage(named: "button-back")
        //UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "button-back")
    }

    // MARK: - Settings configuration
    
    func configureSettings() {
        if SettingsHandler.Defaults.bool(forKey: SettingsHandler.BundleKeys.isNotFirstRun) == false {
            print("KONFIGURACJA")
            //TODO: Ustaw domyślne ustawienia, pokaż samouczek, zezwolenia i ekran konfiguracji kodu
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "PrivateMemories")
        container.loadPersistentStores(completionHandler: { (storeDescription: NSPersistentStoreDescription, error: Error?) in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

