//
//  FloatingDockService.swift
//  FloatingDock
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


enum FDSPError: Error {
    case serviceUnavailable
    case readTimeout
    case loadingDockModel
    
    case openingApplication
}


func FDSPLoadDockConfiguration(from userDirectory: URL) throws -> Dictionary<String, Any> {
    let connectionToService = NSXPCConnection(serviceName: "io.github.FloatingDock.FloatingDockServiceProvider")
    connectionToService.remoteObjectInterface = NSXPCInterface(with: FloatingDockServiceProviderProtocol.self)
    connectionToService.resume()
    
    let replyLock = DispatchGroup()
    var dockConfiguration: Dictionary<String, Any>?
    
    if let proxy = connectionToService.remoteObjectProxy as? FloatingDockServiceProviderProtocol {
        replyLock.enter()
        
        proxy.loadDockConfiguration(from: userDirectory) { dict in
            dockConfiguration = dict
            
            connectionToService.invalidate()
            replyLock.leave()
        }
    } else {
        connectionToService.invalidate()
        throw FDSPError.serviceUnavailable
    }
    
    guard
        // wait for 5 seconds
        replyLock.wait(timeout: .now() + 5) == .success
    else {
        throw FDSPError.readTimeout
    }
    
    if let dockConfiguration {
        return dockConfiguration
    }
    
    throw FDSPError.loadingDockModel
}

func FDSPOpenApplication(at applicationURL: URL) throws {
    let connectionToService = NSXPCConnection(serviceName: "io.github.FloatingDock.FloatingDockServiceProvider")
    connectionToService.remoteObjectInterface = NSXPCInterface(with: FloatingDockServiceProviderProtocol.self)
    connectionToService.resume()
    
    let replyLock = DispatchGroup()
    var runningApplication: NSRunningApplication?
    var openError: Error?
    
    if let proxy = connectionToService.remoteObjectProxy as? FloatingDockServiceProviderProtocol {
        replyLock.enter()
        
        proxy.openApplication(at: applicationURL) { runningApp, err in
            runningApplication = runningApp
            openError = err
            replyLock.leave()
        }
    } else {
        connectionToService.invalidate()
        throw FDSPError.serviceUnavailable
    }
    
    guard
        // wait for 5 seconds
        replyLock.wait(timeout: .now() + 5) == .success
    else {
        throw FDSPError.readTimeout
    }
    
    if let openError {
        throw openError
    }
    
    guard
        let _ = runningApplication
    else {
        throw FDSPError.openingApplication
    }
}
