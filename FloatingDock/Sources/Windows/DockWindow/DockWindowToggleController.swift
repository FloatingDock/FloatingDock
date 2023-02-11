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
import CoreServices
import Foundation
import SwiftUI


class DockWindowToggleController {
    
    // MARK: - Public Static Properties
    
    static var shared: DockWindowToggleController = {
        DockWindowToggleController()
    }()
    
    
    // MARK: - Private Properties
    
    private(set) var dockWindowController: DockWindowController? = nil
    
    
    // MARK: - Initialization
    
    private init() {
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
    
    func openDockWindow() {
        guard
            dockWindowController == nil
        else {
            return
        }
            
        dockWindowController = DockWindowController(launcher: self)
        dockWindowController?.showWindow(self)
    }
    
    func closeDockWindow() {
        dockWindowController?.close()
        dockWindowController = nil
    }
}
