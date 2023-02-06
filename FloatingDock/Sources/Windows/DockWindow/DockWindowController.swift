//
//  DockWindowController.swift
//  FloatingDock
//
//  Created by Thomas Bonk on 31.01.23.
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
import Foundation
import SwiftUI

class DockWindowController: NSWindowController {
    
    // MARK: - Private Properties
    
    private var screenWithMouse: NSScreen? {
        NSScreen
            .screens
            .first {
                NSMouseInRect(NSEvent.mouseLocation, $0.frame, false)
            }
    }
    
    // MARK: - Initialization
    
    init() {
        super.init(window: DockWindowController.makeWindow())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - NSWindowController
    
    override func showWindow(_ sender: Any?) {
        let screen = screenWithMouse!
        let point = NSPoint(x: screen.visibleFrame.midX, y: screen.visibleFrame.midY)
        
        window?.contentViewController = NSHostingController(
            rootView: DockView()
                .background(SettingsModel.shared.dockBackgroundColor.opacity(SettingsModel.shared.dockBackgroundOpacity))
                .cornerRadius(10))
        
        DispatchQueue.main.async {
            let contentSize = self.window!.contentView!.frame.size
            let winOrigin = NSPoint(x: point.x - contentSize.width / 2, y: point.y - contentSize.height / 2)
            
            self.window?.contentView?.setFrameSize(contentSize)
            self.window?.setFrameOrigin(winOrigin)
        }
        DispatchQueue.main.async {
            super.showWindow(sender)
        }
    }
    
    
    // MARK: - Private Static Methods
    
    private static func makeWindow() -> NSWindow {
        let wnd = NSWindow()
        
        let visualEffect = NSVisualEffectView()
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        visualEffect.material = .hudWindow
        visualEffect.state = .active
        visualEffect.wantsLayer = true
        visualEffect.layer?.cornerRadius = 16.0

        wnd.titleVisibility = .hidden
        wnd.styleMask.remove(.titled)
        wnd.backgroundColor = .clear
        wnd.isOpaque = true
        wnd.isMovableByWindowBackground = true
        wnd.contentView?.addSubview(visualEffect)
        wnd.level = .floating

        guard let constraints = wnd.contentView else {
          return wnd
        }

        visualEffect.leadingAnchor.constraint(equalTo: constraints.leadingAnchor).isActive = true
        visualEffect.trailingAnchor.constraint(equalTo: constraints.trailingAnchor).isActive = true
        visualEffect.topAnchor.constraint(equalTo: constraints.topAnchor).isActive = true
        visualEffect.bottomAnchor.constraint(equalTo: constraints.bottomAnchor).isActive = true
        
        return wnd
    }
}
