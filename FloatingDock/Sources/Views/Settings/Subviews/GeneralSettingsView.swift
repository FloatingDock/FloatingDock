//
//  GeneralSettingsView.swift
//  FloatingDock
//
//  Created by Thomas Bonk on 30.01.23.
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

import LaunchAtLogin
import SwiftKeys
import SwiftUI

struct GeneralSettingsView: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        VStack {
            Form {
                Section("Launching Behaviour") {
                    LaunchAtLogin.Toggle("Launch Floating Dock when you login")
                        .padding(.bottom, 5)
                    
                    /* TODO Check how to open a window only if the flag is set
                     Toggle("Import Dock settings when launching", isOn: $importDockSettingsOnLaunch)
                     .padding(.bottom, 30)
                     */
                }
                
                Section("Hotkeys") {
                    HStack {
                        Text("Toggle Floating Dock window")
                        KeyRecorderView(name: .DockWindowToggle)
                    }
                    .padding(.bottom, 30)
                }
            }
            
            Spacer()
        }
    }
    
    
    // MARK: - Private Properties
    
    @AppStorage("importDockSettingsOnLaunch")
    private var importDockSettingsOnLaunch: Bool = false
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}
