//
//  OnboardingWindowController.swift
//  FloatingDock
//
//  Created by Thomas Bonk on 03.02.23.
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
import DTOnboarding
import SwiftUI

class OnboardingWindowController: NSWindowController {
    
    // MARK: - Private Properties
    
    private var onboardingPages = [
        OnboardingPageController(
            controllerId: "ImportDockConfigurationView",
            view: ImportDockConfigurationView().environmentObject(DockModelProvider.shared.dockModel)),
        OnboardingPageController(
            controllerId: "GrantPermissionsToDirectoriesView",
            view: GrantPermissionsToDirectoriesView().environmentObject(DockModelProvider.shared.dockModel)),
        OnboardingPageController(controllerId: "DefineHotkeyView", view: DefineHotkeyView()),
        OnboardingPageController(controllerId: "LaunchAtLogingView", view: LaunchAtLogingView()),
        OnboardingPageController(
            controllerId: "FinishedOnboardingView",
            view: FinishedOnboardingView().environmentObject(DockModelProvider.shared.dockModel))
    ]
    private var onboardingConfig: OnboardingConfig!
    private var onboardingController: DTOnboardingController!
    private var observers = Set<AnyHashable>()
    
    
    // MARK: - Initialization
    
    init() {
        onboardingConfig = OnboardingConfig(
            windowWidth: 500,
            windowHeight: 430,
            windowTitle: "Floating Dock Onboarding",
            pageCount: onboardingPages.count,
            pageControlWidth: 200,
            pageControlHeight: 20,
            pageControlVerticalDistanceFromBottom: 20,
            pageTransitionStyle: .horizontalStrip)
        onboardingController = DTOnboardingController(config: onboardingConfig, pages: onboardingPages)
        
        
        let frame = onboardingController.view.bounds
        let wnd = NSWindow(
            contentRect: .init(origin: .zero, size: frame.size),
            styleMask: [.closable, .miniaturizable, .titled],
            backing: .buffered,
            defer: false)
        
        wnd.title = onboardingConfig.windowTitle
        
        super.init(window: wnd)
        
        self.contentViewController = onboardingController
        
        observers.insert(NotificationCenter.default.addObserver(
            forName: .OnboardingNavigateBack,
            object: nil,
            queue: OperationQueue.main,
            using: navigateBack(notification:)) as! AnyHashable)
        observers.insert(NotificationCenter.default.addObserver(
            forName: .OnboardingNavigateForward,
            object: nil,
            queue: OperationQueue.main,
            using: navigateForward(notification:)) as! AnyHashable)
        observers.insert(NotificationCenter.default.addObserver(
            forName: .OnboardingNavigateToPage,
            object: nil,
            queue: OperationQueue.main,
            using: navigateToPage(notification:)) as! AnyHashable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        observers.forEach { observer in
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    
    // MARK: - NSWindowController
    
    override func showWindow(_ sender: Any?) {
        DispatchQueue.main.async {
            super.showWindow(sender)
        }
        DispatchQueue.main.async {
            self.window?.center()
        }
        DispatchQueue.main.async {
            self.window?.makeKeyAndOrderFront(sender)
        }
        DispatchQueue.main.async {
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    
    // MARK: - Notification Handlers
    
    private func navigateBack(notification: Notification) {
        onboardingController.navigateBack()
    }
    
    private func navigateForward(notification: Notification) {
        onboardingController.navigateForward()
    }
    
    private func navigateToPage(notification: Notification) {
        if let controllerId = notification.object as? String {
            onboardingController.navigate(to: controllerId)
        }
    }
}
