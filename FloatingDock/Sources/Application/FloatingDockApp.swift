//
//  FloatingDockApp.swift
//  FloatingDock
//
//  Created by Thomas Bonk on 29.01.23.
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

import SwiftKeys
import SwiftUI

extension NSNotification.Name {
    static let OpenAppNotification = NSNotification.Name(rawValue: "___OpenAppNotification___")
}


@main
struct FloatingDockApp: App {
    
    // MARK: - Public Properties
    
    var body: some Scene {
        MenuBarExtra("Floating Dock", systemImage: "menubar.dock.rectangle.badge.record") {
            Button("About Floating Dock") {
                NSApplication.shared.showAboutPanel()
            }
            Divider()
            Button("Settings...") {
                NSApplication.shared.showAppSettings()
            }
            Divider()
            Button("Quit Floating Dock") {
                NSApplication.shared.terminate(self)
            }
        }
        
        Settings {
            SettingsView()
        }
    }
    
    
    // MARK: - Private Properties
    
    private let dockWindowToggleCommand = KeyCommand(name: .DockWindowToggle)
    private let onboardingWindowController = OnboardingWindowController()
    
    
    // MARK: - Initialization
    
    init() {
        dockWindowToggleCommand.observe(.keyDown, handler: toggleDockWindow)
        onboardingWindowController.showWindow(self)
    }
    
    
    // MARK: - Private Methods
    
    private func toggleDockWindow() {
        DockWindowToggleController.shared.toggleDockWindow()
    }
}
