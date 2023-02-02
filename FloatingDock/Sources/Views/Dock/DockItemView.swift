//
//  DockItemView.swift
//  FloatingDock
//
//  Created by Thomas Bonk on 02.02.23.
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

struct DockItemView: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        entry.image!
            .resizable()
            .frame(width: iconSize, height: iconSize)
            .scaleEffect(scale)
            .onHover { hovered in
                withAnimation(.linear(duration: 0.2)) {
                    scale = hovered ? SettingsModel.shared.scaleFactor : 1.0
                }
            }
            .onTapGesture {
                NotificationCenter.default.post(name: .OpenAppNotification, object: entry)
            }
    }
    
    var entry: DockEntry
    
    
    // MARK: - Private Properties
    
    @State
    private var scale = 1.0
    
    private var iconSize: CGFloat {
        SettingsModel.shared.iconSize
    }
}

