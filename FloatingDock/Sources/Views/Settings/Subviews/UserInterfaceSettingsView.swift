//
//  UserInterfaceSettingsView.swift
//  FloatingDock
//
//  Created by Thomas Bonk on 12.02.23.
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

struct UserInterfaceSettingsView: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        VStack {
            Form {
                LazyVGrid(columns: [.init(alignment: .trailing), .init(alignment: .leading)], alignment: .center, spacing: 10) {
                    Text("Icons per Row")
                    Slider(value: $iconsPerRow, in: 5...20, step: 1) {
                        EmptyView()
                    } minimumValueLabel: {
                        Text("5")
                    } maximumValueLabel: {
                        Text("20")
                    }
                    
                    Text("Icon Size")
                    Slider(value: $dockIconSize, in: 32...96, step: 8) {
                        EmptyView()
                    } minimumValueLabel: {
                        Text("32")
                    } maximumValueLabel: {
                        Text("96")
                    }
                    
                    Text("Icon Scale Factor")
                    Slider(value: $dockIconScaleFactor, in: 1...1.5, step: 0.1) {
                        EmptyView()
                    } minimumValueLabel: {
                        Text("100%")
                    } maximumValueLabel: {
                        Text("150%")
                    }
                    
                    Text("Background Color")
                    ColorPicker("", selection: $dockBackgroundColor, supportsOpacity: false)
                    
                    Text("Background Opacity")
                    Slider(value: $dockBackgroundOpacity, in: 0...1, step: 0.1) {
                        EmptyView()
                    } minimumValueLabel: {
                        Text("0%")
                    } maximumValueLabel: {
                        Text("100%")
                    }
                }
            }
            Spacer()
        }
    }
    
    
    // MARK: - Private Properties
    
    @AppStorage("dockIconsPerRow")
    private var iconsPerRow: Double = 10
    @AppStorage("dockIconSize")
    private var dockIconSize: Double = 64
    @AppStorage("dockIconScaleFactor")
    private var dockIconScaleFactor: Double = 1.5
    @AppStorage("dockBackgroundColor")
    private var dockBackgroundColor: Color = Color(red: 0.2, green: 0.2, blue: 0.2)
    @AppStorage("dockBackgroundOpacity")
    private var dockBackgroundOpacity: Double = 0.75
}

struct UserInterfaceSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserInterfaceSettingsView()
    }
}
