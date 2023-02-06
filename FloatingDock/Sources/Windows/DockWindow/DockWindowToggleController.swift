//
//  DockWindowToggleController.swift
//  FloatingDock
//
//  Created by Thomas Bonk on 31.01.23.
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

class DockWindowToggleController {
    
    // MARK: - Public Static Properties
    
    static var shared: DockWindowToggleController = {
        DockWindowToggleController()
    }()
    
    
    // MARK: - Private Properties
    
    private var dockWindowController: DockWindowController? = nil
    
    
    // MARK: - Initialization
    
    private init() {
        NotificationCenter.default.addObserver(
            forName: .OpenAppNotification,
            object: nil,
            queue: OperationQueue.main,
            using: startApp(notification:))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Public Methods
    
    func toggleDockWindow() {
        if dockWindowController == nil {
            openDockWindow()
        } else {
            closeDockWindow()
        }
    }
    
    
    // MARK: - Private Methods
    
    private func openDockWindow() {
        dockWindowController = DockWindowController()
        dockWindowController?.showWindow(self)
    }
    
    private func closeDockWindow() {
        dockWindowController?.close()
        dockWindowController = nil
    }
    
    private func startApp(notification: Notification) {
        let entry = notification.object as! DockEntry
        let containingFolderUrl = entry.url!.deletingLastPathComponent()
        let appFilename = entry.url!.lastPathComponent
        
        SandboxFileAccess
            .shared
            .access(
                fileURL: containingFolderUrl,
                askIfNecessary: true,
                fromWindow: dockWindowController?.window,
                persistPermission: true) { result in
                    switch result {
                        case .success(let accessInfo):
                            let appUrl = accessInfo.securityScopedURL?.appendingPathComponent(appFilename)
                            DispatchQueue.main.async {
                                self.closeDockWindow()
                            }
                            DispatchQueue.main.async {
                                NSWorkspace.shared.open(appUrl!)
                            }
                            break
                            
                        case .failure(_):
                            break
                    }
                }
    }
}
