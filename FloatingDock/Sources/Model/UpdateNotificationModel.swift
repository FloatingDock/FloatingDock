//
//  UpdateNotificationModel.swift
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

import Foundation
import UserNotifications

class UpdateNotificationModel {
    
    // MARK: - Static Properties
    
    static var shared: UpdateNotificationModel = {
        UpdateNotificationModel()
    }()
    
    
    // MARK: - Public Methods
    
    public func showUpdateNotification(version: String) {
        let content = updateNotificationContent(version: version)
        let trigger = triggerIn(seconds: 1)

        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("Failed to add a notification request: \(String(describing: error))")
            }
        }
    }
    
    
    // MARK: - Initialization
    
    private init() {
        
        setupNotificationCategories()
    }
    
    
    // MARK: - Private Methods
    
    private func setupNotificationCategories() {
        let categories: [UNNotificationCategory] = Update.Category.allCases
            .map { category in
                let actions = category
                    .availableActions
                    .map { UNNotificationAction(identifier: $0.rawValue, title: $0.title, options: [.foreground]) }

                return UNNotificationCategory(identifier: category.rawValue,
                                              actions: actions,
                                              intentIdentifiers: [],
                                              hiddenPreviewsBodyPlaceholder: "",
                                              options: .customDismissAction)
        }

        UNUserNotificationCenter.current().getNotificationCategories { existingCategories in
            UNUserNotificationCenter
                .current()
                .setNotificationCategories(existingCategories.union(Set(categories)))
        }
    }
    
    private func updateNotificationContent(version: String) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.title = "Floating Dock"
        content.body = "Version \(version) is available."
        content.userInfo = [
            Update.UserInfo.version.rawValue: version
        ]
        content.categoryIdentifier = Update.Category.update.rawValue

        return content
    }
    
    private func triggerIn(seconds: Int) -> UNNotificationTrigger {
        let currentSecond = Calendar.current.component(.second, from: Date())

        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.second = (currentSecond + seconds) % 60

        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    }
    
    
    // MARK: - Update Enum
    
    public enum Update {
        public enum Action: String {
            case downloadUpdate = "DOWNLOAD_UPDATE"
            case downloadLater = "DOWNLOAD_LATER"

            var title: String {
                switch self {
                case .downloadUpdate:
                    return "Download update"
                case .downloadLater:
                    return "Download later"
                }
            }
        }

        public enum Category: String, CaseIterable {
            case update = "UPDATE"

            var availableActions: [Action] {
                switch self {
                case .update:
                    return [.downloadUpdate, .downloadLater]
                }
            }
        }

        public enum UserInfo: String {
            case version = "VERSION_NUMBER"
        }
    }
}
