//
//  SettingsModel.swift
//  FloatingDock
//
//  Created by Thomas Bonk on 30.01.23.
//

import Foundation

extension String {
    static let ImportDockSettingsOnLaunchSettingsKey = "importDockSettingsOnLaunch"
    static let DockModelSettingsKey = "dockModel"
}

class SettingsModel {
    
    // MARK: - Shared instance
    
    static var shared: SettingsModel = {
        SettingsModel()
    }()
    
    
    // MARK: - Public Properties
    
    var importDockSettingsOnLaunch: Bool {
        get {
            UserDefaults.standard.bool(forKey: .ImportDockSettingsOnLaunchSettingsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: .ImportDockSettingsOnLaunchSettingsKey)
        }
    }
    
    var dockModel: Data? {
        get {
            UserDefaults.standard.data(forKey: .DockModelSettingsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: .DockModelSettingsKey)
        }
    }
    
    
    // MARK: - Initialization
    
    private init() {
    }
}
