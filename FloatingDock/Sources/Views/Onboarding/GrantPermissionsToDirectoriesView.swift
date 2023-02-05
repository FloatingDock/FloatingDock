//
//  GrantPermissionsToDirectoriesView.swift
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
import SwiftySandboxFileAccess

fileprivate extension LocalizedStringKey {
    static let noDockConfigImported = LocalizedStringKey("""
You haven't imported the macOS Dock configuration, yet. Please go back to the privious step and import it.
""")
    
    static let explanation = LocalizedStringKey("""
The applications in your Dock are located in the following directories.
Please grant access to each of the directories by clicking the `Grant` button. If you don't grant access, the corresponding applications can't be launched by Floating Dock.
""")
    
    static let allPermissionsGranted = LocalizedStringKey("""
You have already granted access to all directories that contain the applications in your Dock.
You can proceed to the next step.
""")
}

struct GrantPermissionsToDirectoriesView: View, Navigatable {
    
    // MARK: - Public Static Constants
    
    public static let Id = "\(GrantPermissionsToDirectoriesView.self)"
    
    
    // MARK: - Public Properties
    
    var body: some View {
        VStack {
            Text("Grant Permissions to App Directories")
                .font(.title)
                .padding(.bottom, 15)
            
            if dockModel.applications.isEmpty {
                Text(.noDockConfigImported)
                    .bold()
                    .padding(.bottom, 10)
                
                HStack {
                    Button("Import macOS Dock Configuration") {
                        navigate(to: ImportDockConfigurationView.Id)
                    }
                    .buttonStyle(.link)
                    Spacer()
                }
            } else if !dockModel.directoriesWithoutPermission.isEmpty {
                Text(.explanation)
                    .padding(.bottom, 10)
                
                List {
                    ForEach(dockModel.directoriesWithoutPermission, id: \.id) { url in
                        HStack {
                            Text(url.path())
                            Spacer()
                            
                            if urlsWithGrantedAccess.contains(url) {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.green)
                            } else {
                                Button("Grant") {
                                    SandboxFileAccess.shared.access(fileURL: url, askIfNecessary: true, fromWindow: window) { result in
                                        switch result {
                                            case .success(_):
                                                urlsWithGrantedAccess.insert(url)
                                                break
                                                
                                            case .failure(_):
                                                urlsWithGrantedAccess.remove(url)
                                                break
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                Text(.allPermissionsGranted)
            }
            
            Spacer()
            
            if !dockModel.applications.isEmpty && dockModel.directoriesWithoutPermission.isEmpty {
                HStack {
                    Spacer()
                    Button("Next Task") { navigateForward() }
                }
            }
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
    private var urlsWithGrantedAccess = Set<URL>()
    @State
    private var window: NSWindow?
}

struct GrantPermissionsToDirectoriesView_Previews: PreviewProvider {
    static var previews: some View {
        GrantPermissionsToDirectoriesView()
    }
}
