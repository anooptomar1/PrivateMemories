//
//  SettingsHandler.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 06.12.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import Foundation

class SettingsHandler {
    
    static let Defaults = UserDefaults.standard
    
    struct BundleKeys {
        static let appVersion = "app_version"
        static let isNotFirstRun = "first_run"
        static let isAppRated = "app_rated"
        static let code = "code"
        //TODO: static let dummyCode = "dummy_code"
    }
    
    class func setDefault() {
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        Defaults.setValue(true, forKey: BundleKeys.isNotFirstRun)
        Defaults.setValue(false, forKey: BundleKeys.isAppRated)
        Defaults.setValue(version, forKey: BundleKeys.appVersion)
        Defaults.synchronize()
    }
    
}
