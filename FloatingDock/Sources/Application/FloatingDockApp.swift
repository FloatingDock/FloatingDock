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

import Sparkle
import SwiftKeys
import SwiftUI

extension NSNotification.Name {
    // Navigation in the Onboarding UI
    static let OnboardingNavigateBack = NSNotification.Name(rawValue: "___OnboardingNavigateBack___")
    static let OnboardingNavigateForward = NSNotification.Name(rawValue: "__OnboardingNavigateForward__")
    static let OnboardingNavigateToPage = NSNotification.Name(rawValue: "__OnboardingNavigateToPage___")
}


@main
struct FloatingDockApp: App {
    
    // MARK: - Public Properties
    
    var body: some Scene {
        MenuBarExtra("Floating Dock", systemImage: "menubar.dock.rectangle.badge.record") {
            Button("Toggle Floating Dock Panel", action: toggleDockWindow)
            Divider()
            Button("Settings...", action: NSApplication.shared.showAppSettings)
            Button("Open Onboarding Panel...", action: openOnboardingWindow)
            Button("Import Dock Settings", action: DockModelProvider.shared.importDockSettings)
            Divider()
            Button("Update Floasting Dock...", action: self.updaterController.updater.checkForUpdates)
                .disabled(!updaterModel.canCheckForUpdates)
            Button("About Floating Dock...", action: NSApplication.shared.showAboutPanel)
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
    
    private var updaterController: SPUStandardUpdaterController
    private var updaterModel: UpdaterModel
    private let dockWindowToggleCommand = KeyCommand(name: .DockWindowToggle)
    private let onboardingWindowController = OnboardingWindowController()
    private var isOnboarded: Bool {
        return !DockModelProvider.shared.dockModel.applications.isEmpty
            && dockWindowToggleCommand.key != nil
    }
    
    
    // MARK: - Initialization
    
    init() {
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
        updaterModel = UpdaterModel(updater: self.updaterController.updater)
        dockWindowToggleCommand.observe(.keyDown, handler: toggleDockWindow)
        showOnboardingWindowIfTaskAreOpen()
    }
    
    
    // MARK: - Private Methods
    
    private func toggleDockWindow() {
        DockWindowToggleController.shared.toggleDockWindow()
    }
    
    private func showOnboardingWindowIfTaskAreOpen() {
        DispatchQueue.main.async {
            if !isOnboarded {
                onboardingWindowController.showWindow(self)
            }
        }
    }
    
    private func openOnboardingWindow() {
        DispatchQueue.main.async {
            onboardingWindowController.showWindow(self)
        }
    }
}
