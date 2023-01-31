//
//  LicensesView.swift
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

struct LicensesView: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        ScrollView {
            Text(licenses)
        }
    }
    
    
    // MARK: - Initialization
    
    init() {
        if let filepath = Bundle.main.path(forResource: "Licenses", ofType: "md") {
            do {
                licenses = try AttributedString(
                    markdown: try String(contentsOfFile: filepath),
                    options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
            } catch {
                licenses = "Error while loading the file."
            }
        } else {
            licenses = "Error while loading the file."
        }
    }
    
    
    // MARK: - Provate Properties
    
    let licenses: AttributedString
}

struct LicensesView_Previews: PreviewProvider {
    static var previews: some View {
        LicensesView()
    }
}
