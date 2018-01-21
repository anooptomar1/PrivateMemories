//
//  SettingsHandler.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 06.12.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import Foundation

final class SettingsHandler {
    fileprivate let isNotFirstRunKey = "first_run"
    fileprivate let passcodeKey = "code"
    fileprivate let isPasscodeRequiredKey = "isPasscodeRequired"
    
    static let instance = SettingsHandler()
    fileprivate let defaults = UserDefaults.standard
    
    var appVersion: String { get { return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String } }
    
    var appBuild: String { get { return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String } }
    
    var isNotFirstRun: Bool {
        get {
            guard let currentValue = defaults.value(forKey: isNotFirstRunKey) else { return false }
            return currentValue as! Bool
        }
        set {
            defaults.setValue(newValue, forKey: isNotFirstRunKey)
            defaults.synchronize()
        }
    }
    
    var passcode: String {
        get { return defaults.value(forKey: passcodeKey) as! String }
        set {
            defaults.setValue(newValue, forKey: passcodeKey)
            defaults.synchronize()
        }
    }
    
    var isPasscodeRequired: Bool {
        get {
            return defaults.value(forKey: isPasscodeRequiredKey) as! Bool}
        set {
            print("SETTING IS PASSCODE REQUIRED: \(newValue)")
            defaults.setValue(newValue, forKey: isPasscodeRequiredKey)
            defaults.synchronize()
        }
    }
    
    
    func setDefault() {
        defaults.setValue(true, forKey: isNotFirstRunKey)
        defaults.setValue(true, forKey: isPasscodeRequiredKey)
        
        defaults.synchronize()
    }
    
}
