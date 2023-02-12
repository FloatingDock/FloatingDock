//
//  DockView.swift
//  FloatingDock
//
//  Created by Thomas Bonk on 01.02.23.
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

struct DockView: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        if DockModelProvider.shared.dockModel.applications.isEmpty {
            HStack {
                Text("You haven't imported the macOS Dock configuration.\nPlease open the Onboarding Wizard and setup FloatingDock.")
                    .lineLimit(20)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .padding(.all, 10)
            .frame(width: 400, height: 200)
        } else {
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(iconSize + 2), alignment: .center), count: iconsPerRow)) {
                ForEach(dockModel.applications, id: \.id) { entry in
                    DockItemView(entry: entry)
                        .frame(width: gridSize, height: gridSize)
                }
            }
            .padding(.all, 15)
        }
    }
    
    
    // MARK: - Private Properties
    
    @EnvironmentObject
    private var dockModel: DockModel
    
    private var iconsPerRow: Int {
        NSLog("iconsPerRow = \(Int(SettingsModel.shared.iconsPerRow))")
        return Int(SettingsModel.shared.iconsPerRow)
    }
    
    private var iconSize: Double {
        SettingsModel.shared.iconSize
    }
    
    private var gridSize: CGFloat {
        CGFloat(iconSize) + 2.0 * (CGFloat(iconSize) / 48.0)
    }
}

struct DockView_Previews: PreviewProvider {
    static var previews: some View {
        DockView()
    }
}
