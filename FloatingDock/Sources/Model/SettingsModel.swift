//
//  SettingsModel.swift
//  FloatingDock
//
//  Created by Thomas Bonk on 30.01.23.
//  Copyright 2023 Thomas Bonk <thomas@meandmymac.de>
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import SwiftUI

extension String {
    static let DockModelSettingsKey = "dockModel"
    static let DockIconsPerRow = "dockIconsPerRow"
    static let DockIconSize = "dockIconSize"
    static let DockIconScaleFactor = "dockIconScaleFactor"
    static let DockBackgroundColor = "dockBackgroundColor"
    static let DockBackgroundOpacity = "dockBackgroundOpacity"
}

class SettingsModel {
    
    // MARK: - Shared instance
    
    static var shared: SettingsModel = {
        SettingsModel()
    }()
    
    
    // MARK: - Public Properties
    
    var dockModel: Data? {
        get {
            UserDefaults.standard.data(forKey: .DockModelSettingsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: .DockModelSettingsKey)
        }
    }
    
    var iconsPerRow: Double {
        get {
            let val = UserDefaults.standard.double(forKey: .DockIconsPerRow)
            
            return val == 0 ? 10 : val
        }
        set {
            UserDefaults.standard.set(newValue, forKey: .DockIconsPerRow)
        }
    }
    
    var iconSize: Double {
        get {
            let val = UserDefaults.standard.double(forKey: .DockIconSize)
            
            return val == 0 ? 64 : val
        }
        set {
            UserDefaults.standard.set(newValue, forKey: .DockIconSize)
        }
    }
    var scaleFactor: Double {
        get {
            let val = UserDefaults.standard.double(forKey: .DockIconScaleFactor)
            
            return val == 0.0 ? 1.5 : val
        }
        set {
            UserDefaults.standard.set(newValue, forKey: .DockIconScaleFactor)
        }
    }
    var dockBackgroundColor: Color {
        get {
            if let val = UserDefaults.standard.string(forKey: .DockBackgroundColor) {
                return Color(rawValue: val)!
            }
            
            return Color(red: 0.2, green: 0.2, blue: 0.2)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: .DockBackgroundColor)
        }
    }
    var dockBackgroundOpacity: Double {
        get {
            let val = UserDefaults.standard.double(forKey: .DockBackgroundOpacity)
            
            return val == 0.0 ? 0.75 : val
        }
        set {
            UserDefaults.standard.set(newValue, forKey: .DockBackgroundOpacity)
        }
    }
    
    
    // MARK: - Initialization
    
    private init() {
    }
    
    
    // MARK: - Private Properties
    
    private func key(for url: URL) -> String {
        let key = "\(url)"
        
        return key
    }
}
