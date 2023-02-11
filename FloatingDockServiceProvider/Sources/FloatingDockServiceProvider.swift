//
//  FloatingDockServiceProvider.swift
//  FloatingDockServiceProvider
//
//  Created by Thomas Bonk on 10.02.23.
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


/// This object implements the protocol which we have defined. It provides the actual behavior for
/// the service. It is 'exported' by the service to make it available to the process hosting the
/// service over an NSXPCConnection.
class FloatingDockServiceProvider: NSObject, FloatingDockServiceProviderProtocol {

    /// read the macOS Dock configuration and call the reply handler
    @objc func loadDockConfiguration(from userHome: URL, with reply: @escaping (Dictionary<String, Any>?) -> Void) {
        let dockConfigUrl = userHome
          .appendingPathComponent("Library")
          .appendingPathComponent("Preferences")
          .appendingPathComponent("com.apple.dock.plist")
        
        let dockConfiguration = NSDictionary(contentsOf: dockConfigUrl) as? Dictionary<String, Any>
        reply(dockConfiguration)
    }
    
    /// open an application
    @objc func openApplication(at applicationURL: URL, completionHandler: ((Error?) -> Void)?) {
        var error: Error?
        let replyLock = DispatchGroup()
        replyLock.enter()
        
        NSWorkspace
            .shared
            .openApplication(
                at: applicationURL,
                configuration: {
                    let configuration = NSWorkspace.OpenConfiguration()
                    configuration.activates = true
                    return configuration
                }()) { runningApp, err in
                    error = err
                    replyLock.leave()
                }
        
        _ = replyLock.wait(timeout: .now() + 5)
        
        completionHandler?(error)
    }
}
