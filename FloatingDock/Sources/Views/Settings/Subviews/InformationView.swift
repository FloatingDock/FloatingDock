//
//  InformationView.swift
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

import SwiftUI

struct InformationView: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .frame(width: 128, height: 128)
                .padding(.all, 20)
            Text("Copyright © 2023 Thomas Bonk")
            Text("Version \(Bundle.main.releaseVersionNumber!) (\(Bundle.main.buildVersionNumber!))")
        }
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
