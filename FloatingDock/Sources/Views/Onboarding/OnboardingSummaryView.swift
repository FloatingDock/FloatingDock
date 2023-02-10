//
//  OnboardingSummaryView.swift
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
    static let allIsDone = LocalizedStringKey("""
Congratulations! You've setup Floating Dock and you can use it from now on!

You can close this window now.
""")
    
    static let openTasks = LocalizedStringKey("""
There are open tasks that you haven't completed. You can navigate to the corresponding tasks by clicking the links below.
""")
}

struct OnboardingSummaryView: View, Navigatable {
    
    // MARK: - Public Static Constants
    
    public static let Id = "\(OnboardingSummaryView.self)"
    
    
    // MARK: - Public Properties
    
    var body: some View {
        VStack {
            Text("Summary")
                .font(.title)
                .padding(.bottom, 15)
            
            if areAllMandotaryTaskDone {
                Text(.allIsDone)
            } else {
                Text(.openTasks)
                
                VStack {
                    if dockModel.applications.isEmpty {
                        HStack {
                            Button("Import macOS Dock Configuration") {
                                navigate(to: ImportDockConfigurationView.Id)
                            }
                            .buttonStyle(.link)
                            Spacer()
                        }
                    }
                    
                    if KeyCommand(name: .DockWindowToggle).key == nil {
                        HStack {
                            Button("Define Hotkey to Toggle the Floating Dock Panel") {
                                navigate(to: DefineHotkeyView.Id)
                            }
                            .buttonStyle(.link)
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.all, 30)
    }
    
    
    // MARK: - Public Properties
    
    @EnvironmentObject
    private var dockModel: DockModel
    
    private var areAllMandotaryTaskDone: Bool {
        return !dockModel.applications.isEmpty
    }
}

struct FinishedOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingSummaryView()
    }
}
