//
//  DataImportView.swift
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

import SwiftUI

struct DataImportView: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        Form {
            Section("Import Settings") {
                Button("Import macOS Dock settings") {
                    DockModelProvider.shared.importDockSettings(window) { error in
                        
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)) { notification in
            if let window = notification.object as? NSWindow {
                self.window = window
            }
        }
    }
    
    
    // MARK: - Private Properties
    
    @State
    private var window: NSWindow?
}

struct DataImportView_Previews: PreviewProvider {
    static var previews: some View {
        DataImportView()
    }
}
