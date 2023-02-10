//
//  FloatingDockServiceProviderProtocol.swift
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

/// The protocol that this service will vend as its API. This protocol will also need to be visible
/// to the process hosting the service.
@objc protocol FloatingDockServiceProviderProtocol {
    
    /// read the macOS Dock configuration and call the reply handler
    func loadDockConfiguration(from userHome: URL, with reply: @escaping (Dictionary<String, Any>?) -> Void)
    
    /// open an application
    func openApplication(at applicationURL: URL, completionHandler: ((NSRunningApplication?, Error?) -> Void)?)
}

/*
 To use the service from an application or other process, use NSXPCConnection to establish a
 connection to the service by doing something like this:

     let connectionToService = NSXPCConnection(serviceName: "io.github.FloatingDock.FloatingDockServiceProvider")
     connectionToService.remoteObjectInterface = NSXPCInterface(with: FloatingDockServiceProviderProtocol.self)
     connectionToService.resume()

 Once you have a connection to the service, you can use it like this:

     if let proxy = connectionToService.remoteObjectProxy as? FloatingDockServiceProviderProtocol {
         proxy.uppercase(string: "hello") { aString in
             NSLog("Result string was: \(aString)")
         }
     }

 And, when you are finished with the service, clean up the connection like this:

     connectionToService.invalidate()
*/
