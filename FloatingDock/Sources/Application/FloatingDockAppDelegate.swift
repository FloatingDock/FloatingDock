//
//  FloatingDockAppDelegate.swift
//  FloatingDock
//
//  Created by Thomas Bonk on 19.11.23.
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
import UserNotifications

public class FloatingDockAppDelegate: NSResponder, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    
    // MARK: - Static Properties
    
    public private(set) static var instance: FloatingDockAppDelegate!
    
    // MARK: - Public Properties
    
    public let updater: HawkUpdater
    
    
    // MARK: - Initialization
    
    override init() {
        self.updater = HawkUpdater(
            owner: "FloatingDock",
            repository: "FloatingDock",
            backgroundCheck: SettingsModel.shared.autoUpdate,
            onError: FloatingDockAppDelegate.updaterErrorOcurred,
            onUpdateAvailable: FloatingDockAppDelegate.updateAvailable)
        self.updater.backgroundCheck = SettingsModel.shared.autoUpdate
        
        super.init()
        
        FloatingDockAppDelegate.instance = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - NSApplicationDelegate
    
    public func applicationDidFinishLaunching(_ notification: Notification) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge, .provisional]) { granted, error in
                    
        }
        notificationCenter.delegate = self
    }
    
    
    // MARK: - UNUserNotificationCenterDelegate
    
    /** Handle notification when the app is in background */
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
  
        switch response.actionIdentifier {
        case UpdateNotificationModel.Update.Action.downloadLater.rawValue:
            completionHandler()
            break
            
        case UpdateNotificationModel.Update.Action.downloadUpdate.rawValue:
            let userInfo = response.notification.request.content.userInfo
            let version = userInfo.first?.value as? String
            Task {
                await updater.downloadUpdate(version: version)
            }
            completionHandler()
            break
            
        default:
            completionHandler()
            break
        }
        // handle the notification here
    }
    
    /** Handle notification when the app is in foreground */
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
       
        completionHandler(.banner)
    }
    
    
    // MARK: - Private Static Methods
    
    private static func updaterErrorOcurred(_ error: Error) {
        ErrorNotificationModel.shared.showErrorNotification(text: "Can't update application.", error: error)
    }

    private static func updateAvailable(_ version: String) {
        UpdateNotificationModel.shared.showUpdateNotification(version: version)
    }
}
