//
//  DefineHotkeyView.swift
//  FloatingDock
//
//  Created by Thomas Bonk on 04.02.23.
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

fileprivate extension LocalizedStringKey {
    static let explanation = LocalizedStringKey("""
You can bring up the Floating Dock panel by pressing a hotkey. The same hotkey is used to hide the Floating Dock panel again.

Here you can define the hotkey to toggle the Floating Dock panel.
""")
}

struct DefineHotkeyView: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        VStack {
            Text("Define Hotkey")
                .font(.title)
                .padding(.bottom, 15)
            
            Text(.explanation)
                .padding(.bottom, 15)
            
            HStack {
                Text("Hotkey: ")
                KeyRecorderView(name: .DockWindowToggle)
            }
            
            Spacer()
        }
        .padding(.all, 30)
    }
}

struct DefineHotkeyView_Previews: PreviewProvider {
    static var previews: some View {
        DefineHotkeyView()
    }
}
