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
import UserNotifications

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
            SettingsLink(label: { Text("Settings...") })
            Button("Open Onboarding Panel...", action: openOnboardingWindow)
            Button("Import Dock Settings", action: DockModelProvider.shared.importDockSettings)
            Divider()
            Button("Check Update...", action: checkUpdate)
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
    
    @NSApplicationDelegateAdaptor(FloatingDockAppDelegate.self)
    private var appDelegate
    private let dockWindowToggleCommand = KeyCommand(name: .DockWindowToggle)
    private let onboardingWindowController = OnboardingWindowController()
    private var isOnboarded: Bool {
        return !DockModelProvider.shared.dockModel.applications.isEmpty
            && dockWindowToggleCommand.key != nil
    }
    
    
    // MARK: - Initialization
    
    init() {
        dockWindowToggleCommand.observe(.keyDown, handler: toggleDockWindow)
        showOnboardingWindowIfTasksAreOpen()
        importDockModel()
    }
    
    
    // MARK: - Private Methods
    
    private func checkUpdate() {
        Task {
            await FloatingDockAppDelegate.instance.updater.checkUpdate()
        }
    }
    
    private func toggleDockWindow() {
        DockWindowToggleController.shared.toggleDockWindow()
    }
    
    private func showOnboardingWindowIfTasksAreOpen() {
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
    
    private func importDockModel() {
        if isOnboarded && SettingsModel.shared.importDockSettingsOnLaunch {
            DockModelProvider.shared.importDockSettings { error in
                if error == nil {
                    try? DockModelProvider.shared.saveModel()
                }
            }
        }
    }
}
