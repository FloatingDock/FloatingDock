//
//  OnboardingPageController.swift
//  FloatingDock
//
//  Created by Thomas Bonk on 03.02.23.
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

import DTOnboarding
import Foundation
import SwiftUI

class OnboardingPageController<Content: View>: DTPageController {
    
    // MARK: - Private Properties
    
    private var viewController: NSHostingController<Content>
    
    
    // MARK: - Initialization
    
    public init(controllerId: String, view: Content) {
        viewController = NSHostingController(rootView: view)
        super.init(controllerId: controllerId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - DTPageController
    
    override func loadView() {
        view = viewController.view
    }
}
