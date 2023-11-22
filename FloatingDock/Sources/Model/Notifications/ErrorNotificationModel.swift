//
//  ErrorNotificationModel.swift
//  FloatingDock
//
//  Created by Thomas Bonk on 22.11.23.
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

class ErrorNotificationModel {
    
    // MARK: - Static Properties
    
    static var shared: ErrorNotificationModel = {
        ErrorNotificationModel()
    }()
    
    // MARK: - Public Methods
    
    public func showErrorNotification(text: String, error: Error? = nil) {
        let content = errorNotificationContent(version: version)
        let trigger = triggerIn(seconds: 1)

        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("Failed to add a notification request: \(String(describing: error))")
            }
        }*/
    }
}
