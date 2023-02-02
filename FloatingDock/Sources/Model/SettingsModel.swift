//
//  SettingsModel.swift
//  FloatingDock
//
//  Created by Thomas Bonk on 30.01.23.
//

import Foundation
import SwiftySandboxFileAccess
import SwiftUI

extension String {
    static let ImportDockSettingsOnLaunchSettingsKey = "importDockSettingsOnLaunch"
    static let DockModelSettingsKey = "dockModel"
}

class SettingsModel: SandboxFileAccessProtocol {
    
    
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
    
    var iconSize: CGFloat = 64
    var scaleFactor = 1.5
    var dockBackgroundColor = Color(red: 0.2, green: 0.2, blue: 0.2)
    var dockBackgroundOpacity = 0.75
    
    
    // MARK: - Initialization
    
    private init() {
    }
    
    
    // MARK: - SandboxFileAccessProtocol
    
    func bookmarkData(for url: URL) -> Data? {
        let key = key(for: url)
        let data = UserDefaults.standard.data(forKey: key)
        
        return data
    }
    
    func setBookmark(data: Data?, for url: URL) {
        if let data {
            let key = key(for: url)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func clearBookmarkData(for url: URL) {
        let key = key(for: url)
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    
    // MARK: - Private Properties
    
    private func key(for url: URL) -> String {
        let key = "\(url)"
        
        return key
    }
}
