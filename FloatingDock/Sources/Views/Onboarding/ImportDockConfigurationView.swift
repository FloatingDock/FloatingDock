//
//  ImportDockConfigurationView.swift
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

import SwiftUI

fileprivate extension LocalizedStringKey {
    static let explanation = LocalizedStringKey("""
In the first step, we're importing the configuration of the macOS Dock.

Please push the button to start the import. A file open panel might be displayed because Floating Panel needs your permission to do so.
Please grant access to that file. Otherwise the macOS Dock configuration can't be imported.
""")
    
    static let alreadyImportedExplanation = LocalizedStringKey("""
You have already imported the configuration of the macOS DOck.

If you want to re-import the Dock configuration then push the button to start the import. A file open panel might be displayed because Floating Panel needs your permission to do so.
Please grant access to that file. Otherwise the macOS Dock configuration can't be imported.
""")
}

struct ImportDockConfigurationView: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        VStack {
            Text("Import macOS Dock Configuration")
                .font(.title)
                .padding(.bottom, 15)
            
            if dockModel.applications.isEmpty {
                Text(.explanation)
                    .multilineTextAlignment(.leading)
            } else {
                Text(.alreadyImportedExplanation)
            }
            
            Spacer()
            
            Image(systemName: "hand.point.down")
                .resizable()
                .frame(width: 58, height: 64)
                .padding(.bottom, 10)
            
            Button("Import Configuration") {
                DockModelProvider.shared.importDockSettings(window) { error in
                    if let error {
                        message = error.localizedDescription
                        messageVisible = true
                        return
                    }
                    
                    messageVisible = true
                    message = "The macOS Dock configuration has been imported. You can continue to the next step."
                }
            }
            
            Spacer()
            
            if messageVisible {
                Text(message)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(.all, 30)
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)) { notification in
            if let window = notification.object as? NSWindow {
                self.window = window
            }
        }
    }
    
    
    // MARK: - Private Properties
    
    @EnvironmentObject
    private var dockModel: DockModel
    @State
    private var window: NSWindow?
    @State
    private var messageVisible = false
    @State
    private var message = "<Message>"
}

struct SelectRootDirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        ImportDockConfigurationView()
    }
}
