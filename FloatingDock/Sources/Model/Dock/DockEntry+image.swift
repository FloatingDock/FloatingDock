//
//  DockEntry+image.swift
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

import AppKit
import SwiftUI

extension DockEntry {
    var image: Image? {
        guard let path = url?.path else {
          return nil
        }

        return Image(nsImage: NSWorkspace.shared.icon(forFile: path))
    }
}
