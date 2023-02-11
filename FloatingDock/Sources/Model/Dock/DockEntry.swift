//
//  DockEntry.swift
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

import AppKit
import Foundation

class DockEntry: Codable, Identifiable, ObservableObject {
    
    // MARK: - Public Properties
    
    @Published
    public var id: Int = 0
    @Published
    public var label: String = ""
    @Published
    public var bundleIdentifier: String = ""
    @Published
    public var url: URL? = nil
    @Published
    public var isRunning: Bool! = false
    
    
    // MARK: - Private Properties
    
    private var updateTimer: Timer!
    
    
    // MARK: - Initialization
    
    init(id: Int = 0, label: String, bundleIdentifier: String, url: URL?) {
        self.id = id
        self.label = label
        self.bundleIdentifier = bundleIdentifier
        self.url = url
        
        startTimers()
    }
    
    deinit {
        updateTimer.invalidate()
    }
    
    
    // MARK: - Codable
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        label = try container.decode(String.self, forKey: .label)
        bundleIdentifier = try container.decode(String.self, forKey: .bundleIdentifier)
        url = try? container.decode(URL.self, forKey: .url)
        
        startTimers()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(label, forKey: .label)
        try container.encode(bundleIdentifier, forKey: .bundleIdentifier)
        if let url {
            try container.encode(url, forKey: .url)
        }
    }
    
    
    // MARK: - Private Methods
    
    private func startTimers() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true, block: { _ in
            DispatchQueue.main.async {
                self.isRunning = !NSRunningApplication.runningApplications(withBundleIdentifier: self.bundleIdentifier).isEmpty
            }
        })
    }
    
    
    // MARK: - Coding Keys
    
    public enum CodingKeys: CodingKey {
        case id
        case label
        case bundleIdentifier
        case url
    }
}

