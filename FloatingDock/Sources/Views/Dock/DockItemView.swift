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
        ZStack {
            entry.image!
                .resizable()
                .frame(width: CGFloat(iconSize), height: CGFloat(iconSize))
                .scaleEffect(scale)
            
            if self.entry.isRunning {
                VStack {
                    Spacer()
                    HStack {
                        ZStack {
                            Circle()
                                .foregroundColor(.green)
                                .frame(width: indicatorSize, height: indicatorSize)
                                .blur(radius: indicatorSize / 3)
                            Circle()
                                .foregroundColor(.green)
                                .frame(width: indicatorSize, height: indicatorSize)
                        }
                        Spacer()
                    }
                }
            }
        }
        .onHover { hovered in
            withAnimation(.linear(duration: 0.2)) {
                scale = hovered ? SettingsModel.shared.scaleFactor : 1.0
            }
        }
        .onTapGesture {
            launcher.launchApplication(from: entry, completionHandler: nil, errorHandler: nil)
        }
    }
    
    @ObservedObject
    var entry: DockEntry
    
    
    // MARK: - Private Properties
    
    @State
    private var scale = 1.0
    @Environment(\.applicationLauncher)
    private var launcher
    
    private let indicatorSize = 8.0
    private var iconSize: Double {
        SettingsModel.shared.iconSize
    }
}

