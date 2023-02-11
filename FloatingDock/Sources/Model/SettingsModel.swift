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
    
    var iconSize: CGFloat = 64
    var scaleFactor = 1.5
    var dockBackgroundColor = Color(red: 0.2, green: 0.2, blue: 0.2)
    var dockBackgroundOpacity = 0.75
    
    
    // MARK: - Initialization
    
    private init() {
    }
    
    
    // MARK: - Private Properties
    
    private func key(for url: URL) -> String {
        let key = "\(url)"
        
        return key
    }
}
