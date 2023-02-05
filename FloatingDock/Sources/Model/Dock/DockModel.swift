//
//  DockModel.swift
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

class DockModel: Codable, ObservableObject {
    
    // MARK: - Public Properties
    
    @Published
    public var applications: [DockEntry]
    
    
    // MARK: - Initialization
    
    init() {
        applications = []
    }
    
    
    // MARK: - Codable
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        applications = try container.decode([DockEntry].self, forKey: .applications)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(applications, forKey: .applications)
    }
    

    // MARK: - Coding Keys
    
    public enum CodingKeys: CodingKey {
        case applications
    }
}
