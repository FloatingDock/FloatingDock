//
//  DockWindowToggleController+ApplicationLauncher.swift
//  FloatingDock
//
//  Created by Thomas Bonk on 10.02.23.
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
import SwiftUI

struct ApplicationLauncherKey: EnvironmentKey {
    static let defaultValue: any ApplicationLauncher = DockWindowToggleController.shared
}

extension EnvironmentValues {
  var applicationLauncher: any ApplicationLauncher {
    get { self[ApplicationLauncherKey.self] }
  }
}

extension DockWindowToggleController: ApplicationLauncher {
    
    // MARK: - ApplicationLauncher
    
    func launchApplication(from entry: DockEntry, completionHandler: CompletionHandler? = nil, errorHandler: ErrorHandler? = nil) {
        do {
            try FDSPOpenApplication(at: entry.url!)
            completionHandler?()
            self.closeDockWindow()
        } catch {
            errorHandler?(error)
        }
    }
}
