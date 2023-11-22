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

class ErrorNotificationModel: BaseNotificationModel {
    
    // MARK: - Static Properties
    
    static var shared: ErrorNotificationModel = {
        ErrorNotificationModel()
    }()
    
    // MARK: - Public Methods
    
    public func showErrorNotification(text: String, error: Error? = nil) {
        showNotification(
            content: errorNotificationContent(text: text, error: error),
            trigger: triggerIn(seconds: 1))
    }
    
    
    // MARK: - Initialization
    
    private init() {}
    
    
    // MARK: - Private Methods
    
    private func errorNotificationContent(text: String, error: Error?) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.title = "Floating Dock"
        content.subtitle = "Error"
        content.body = "\(text)"
        
        if let error {
            content.body = content.body + "\n\(error.localizedDescription)"
        }
        
        return content
    }
}
