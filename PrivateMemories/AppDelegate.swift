//
//  AppDelegate.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 30.10.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit
import CoreData
import TOPasscodeViewController
import LocalAuthentication

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let settingsHandler = SettingsHandler.instance

    //TODO: Logika dla galerii, alerty, dodać ViewAnimator, touchID (w ustawieniach również)

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
        print("IS NOT FIRST RUN: \(settingsHandler.isNotFirstRun)")
        if settingsHandler.isNotFirstRun == true, settingsHandler.isPasscodeRequired {
            presentCodeView(animated: false)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    func setNewPassword() {
        guard let rootViewController = getTopViewController() else { print("PRESENT CODE VIEW FAILED"); return }
        let passcodeSettingsViewController = TOPasscodeSettingsViewController(style: .dark)
        passcodeSettingsViewController.delegate = self
        passcodeSettingsViewController.passcodeType = .sixDigits
        passcodeSettingsViewController.requireCurrentPasscode = true
        rootViewController.present(passcodeSettingsViewController, animated: true, completion: nil)
    }

    func presentCodeView(animated: Bool) {
        print("PRESENT CODE VIEW")
        guard let rootViewController = getTopViewController() else { print("PRESENT CODE VIEW FAILED"); return }
        let passcodeViewController = TOPasscodeViewController(style: .translucentDark, passcodeType: .sixDigits)
        passcodeViewController.allowBiometricValidation = false //checkIfTouchIDAvailable()
        passcodeViewController.rightAccessoryButton = UIButton()
        passcodeViewController.accessoryButtonTintColor = UIColor.turquoise
        passcodeViewController.inputProgressViewTintColor = UIColor.turquoise
        passcodeViewController.keypadButtonTextColor = UIColor.turquoise
        passcodeViewController.delegate = self
        rootViewController.present(passcodeViewController, animated: animated, completion: nil)
    }
    
    func getTopViewController() -> UIViewController? {
        if var topViewController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topViewController.presentedViewController {
                topViewController = presentedViewController
            }
            return topViewController
        } else { return nil }
    }
    
    func checkIfTouchIDAvailable() -> Bool {
        if #available(iOS 8.0, *) {
            return LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        }
        return false
    }
    
    // MARK: - Layout customization
    
    func configureLayoutAppearance() {
        UIApplication.shared.statusBarStyle = .lightContent
        //UINavigationBar.appearance().backIndicatorImage = UIImage(named: "button-back")
        //UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "button-back")
    }

    // MARK: - Settings configuration
    
    func configureSettings() {
        print("CONFIGURING SETTINGS")
        if settingsHandler.isNotFirstRun == false {
            print("IS FIRST RUN")
            settingsHandler.setDefault()
            print("SET DEFAULT")
            //presentOnboardingView
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

extension AppDelegate: TOPasscodeViewControllerDelegate {
    func passcodeViewController(_ passcodeViewController: TOPasscodeViewController, isCorrectCode code: String) -> Bool {
        return code == SettingsHandler().passcode
    }
    
    func didInputCorrectPasscode(in passcodeViewController: TOPasscodeViewController) {
        passcodeViewController.dismiss(animated: true, completion: nil)
    }
    
    func didPerformBiometricValidationRequest(in passcodeViewController: TOPasscodeViewController) {
        //let authContext = LAContext()
    }
}

extension AppDelegate: TOPasscodeSettingsViewControllerDelegate {
    func passcodeSettingsViewController(_ passcodeSettingsViewController: TOPasscodeSettingsViewController, didChangeToNewPasscode passcode: String, of type: TOPasscodeType) {
        settingsHandler.passcode = passcode
        passcodeSettingsViewController.dismiss(animated: true, completion: nil)
    }
}

