//
//  LaunchAtLogingView.swift
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

import LaunchAtLogin
import SwiftUI

fileprivate extension LocalizedStringKey {
    static let explanation = LocalizedStringKey("""
You can launch Floating Dock automatically when you login to your macOS account. Just enable the flag below!
""")
}

struct LaunchAtLogingView: View, Navigatable {
    
    // MARK: - Public Static Constants
    
    public static let Id = "\(LaunchAtLogingView.self)"
    
    
    // MARK: - Public Properties
    
    var body: some View {
        VStack {
            Text("Launch at Login")
                .font(.title)
                .padding(.bottom, 15)
            
            Text(.explanation)
                .padding(.bottom, 15)
            
            LaunchAtLogin.Toggle("Automatically launch Floating Dock when you login")
            
            Spacer()
            
            HStack {
                Spacer()
                Button("Show Summary") { navigateForward() }
            }
        }
        .padding(.all, 30)
    }
}

struct LaunchAtLogingView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchAtLogingView()
    }
}
