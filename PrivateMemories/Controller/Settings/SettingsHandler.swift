//
//  SettingsHandler.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 06.12.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import Foundation

class SettingsHandler {
    fileprivate let appVersionKey = "app_version"
    fileprivate let isNotFirstRunKey = "first_run"
    fileprivate let isAppRatedKey = "app_rated"
    fileprivate let passcodeKey = "code"
    //TODO: fileprivate let dummyPasscode = "dummy_code"
    
    fileprivate let defaults = UserDefaults.standard
    
    var appVersion: String { get { return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String } }
    
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
    
    var isAppRated: Bool {
        get { return defaults.value(forKey: isAppRatedKey) as! Bool}
        set {
            defaults.setValue(newValue, forKey: isAppRatedKey)
            defaults.synchronize()
        }
    }
    
    var passcode: String {
        get {
            if let passcode = defaults.value(forKey: passcodeKey) {
            return passcode as! String
        } else {
                return "123456"
        }}
        set {
            defaults.setValue(newValue, forKey: passcodeKey)
            defaults.synchronize()
        }
    }
    
    func setDefault() {
        defaults.setValue(true, forKey: isNotFirstRunKey)
        defaults.setValue(false, forKey: isAppRatedKey)
        //TODO: Zmienić
        defaults.setValue("123456", forKey: passcodeKey)
        defaults.synchronize()
    }
    
}
