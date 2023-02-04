//
//  FinishedOnboardingView.swift
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

import SwiftUI

fileprivate extension LocalizedStringKey {
    static let allIsDone = LocalizedStringKey("""
Congratulations! You've setup Floating Dock and you can use it from now on!

You can close this window now.
""")
    
    static let alreadyImportedExplanation = LocalizedStringKey("""
You have already imported the configuration of the macOS DOck.

If you want to re-import the Dock configuration then push the button to start the import. A file open panel might be displayed because Floating Panel needs your permission to do so.
Please grant access to that file. Otherwise the macOS Dock configuration can't be imported.
""")
}

struct FinishedOnboardingView: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        VStack {
            Text("Summary")
                .font(.title)
                .padding(.bottom, 15)
            
            if areAllMandotaryTaskDone {
                Text(.allIsDone)
            } else {
                Text("There are open tasks! TODO!!!")
            }
            
            Spacer()
        }
        .padding(.all, 30)
    }
    
    
    // MARK: - Public Properties
    
    @EnvironmentObject
    private var dockModel: DockModel
    
    private var areAllMandotaryTaskDone: Bool {
        return !dockModel.applications.isEmpty && dockModel.directoriesWithoutPermission.isEmpty
    }
}

struct FinishedOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        FinishedOnboardingView()
    }
}
