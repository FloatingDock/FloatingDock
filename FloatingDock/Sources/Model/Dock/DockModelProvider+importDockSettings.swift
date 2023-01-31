//
//  DockModelProvider+importDockSettings.swift
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
import SwiftySandboxFileAccess

fileprivate extension String {
    static let PersistentApplications = "persistent-apps"
    static let GUID                   = "GUID"
    static let TileData               = "tile-data"
    static let FileLabel              = "file-label"
    static let BundleIdentifier       = "bundle-identifier"
    static let FileData               = "file-data"
    static let FileURL                = "_CFURLString"
}

extension DockModelProvider {
    
    func importDockSettings(_ window: NSWindow?, onError: ((Error) -> ())? = nil) {
        SandboxFileAccess()
            .access(
                fileURL: .dockConfiguration,
                askIfNecessary: true,
                fromWindow: window,
                persistPermission: true) { sandboxResult in
                    
                    switch sandboxResult {
                        case .success(let accessInfo):
                            guard
                                let url = accessInfo.securityScopedURL
                            else {
                                onError?(ApplicationError.noSecutrityScopedUrl)
                                return
                            }
                            
                            do {
                                try self.importDockModel(from: URL.saveDockConfiguration(url))
                            } catch {
                                onError?(error)
                            }
                            break
                            
                        case .failure(let error):
                            onError?(error)
                            break
                    }
                }
    }
    
    
    // MARK: - Private Methods
    
    private func importDockModel(from url: URL) throws {
        guard
            let dockConfiguration = NSDictionary(contentsOf: url) as? Dictionary<String, Any>
        else {
            throw ApplicationError.importDockModelError
        }
        
        if let persistentApplications = dockConfiguration[.PersistentApplications] as? Array<Dictionary<String, Any>> {
            persistentApplications.map(toDockEntry(app:)).forEach { entry in
                self.dockModel.applications.append(entry)
            }
        }
        
        try self.saveModel()
    }
    
    private func toDockEntry(app: Dictionary<String, Any>) -> DockEntry {
        let tileData = toDictionary(app[.TileData]!)
        let id = toInt(app[.GUID]!)
        let label = toString(tileData[.FileLabel]!)
        let bundleIdentifier = toString(tileData[.BundleIdentifier]!)
        let url = URL(string: toString(toDictionary(tileData[.FileData]!)[.FileURL]!))
        
        return DockEntry(id: id, label: label, bundleIdentifier: bundleIdentifier, url: url)
    }
    
    private func toInt(_ data: Any) -> Int {
        return Int(truncating: (data as! NSNumber))
    }
    
    private func toDictionary(_ data: Any) -> Dictionary<String, Any> {
        return data as! Dictionary<String, Any>
    }
    
    private func toString(_ data: Any) -> String {
        return data as! String
    }
}
