//
//  DockModelProvider.swift
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

class DockModelProvider {
    
    // MARK: - Static Properties
    
    static var shared: DockModelProvider = {
        DockModelProvider()
    }()
    
    
    // MARK: - Public Properties
    
    var dockModel: DockModel!
    
    
    // MARK: - Initialization
    
    private init() {
        try? loadModel()
        //dockModel = DockModel()
    }
    
    
    // MARK: - Retrieving and saving the dockmodel
    
    public func saveModel() throws {
        SettingsModel.shared.dockModel = try JSONEncoder().encode(dockModel)
    }
    
    public func loadModel() throws {
        if let data = SettingsModel.shared.dockModel {
            dockModel = try JSONDecoder().decode(DockModel.self, from: data)
        } else {
            dockModel = DockModel()
        }
    }
}
