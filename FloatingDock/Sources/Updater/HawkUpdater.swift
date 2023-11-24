//
//  HawkUpdater.swift
//  HawkUpdater
//
//  Created by Thomas Bonk on 18.11.23.
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
import HawkExtensions
import Version


public typealias ErrorCallback = (Error) -> Void
public typealias UpdateAvailableCallback = (String) -> Void


public class HawkUpdater {
    
    // MARK: - Public Enums
    
    public enum UpdateTask {
        case check
        case install
    }
    
    // MARK: - Public Properties
    
    public var backgroundCheck: Bool = false {
        didSet {
            startOrStopScheduler()
        }
    }
    
    // MARK: - Private Properties
    
    private var owner: String
    private var repository: String
    private var onError: ErrorCallback
    private var onUpdateAvailable: UpdateAvailableCallback
    private var scheduler: Timer? = nil
    
    
    // MARK: - Initialization
    
    public init (
        owner: String,
        repository: String,
        backgroundCheck: Bool = false,
        onError: ErrorCallback? = nil,
        onUpdateAvailable: UpdateAvailableCallback? = nil) {
            
        self.owner = owner
        self.repository = repository
        self.backgroundCheck = backgroundCheck
        self.onError = { error in
            DispatchQueue.main.async {
                onError?(error)
            }
        }
        self.onUpdateAvailable = { version in
            DispatchQueue.main.async {
                onUpdateAvailable?(version)
            }
        }
    }
    
    deinit {
        if let _ = scheduler {
            self.scheduler?.invalidate()
            self.scheduler = nil
        }
    }
    
    
    // MARK: - Public Methods
    
    public func checkUpdate() async {
        do {
            let currentVersion = Bundle.main.version
            let releases = try await loadReleases()
            
            if let updateVersion = releases.findViableUpdateVersion(appVersion: currentVersion, repo: repository) {
                self.onUpdateAvailable(updateVersion)
            }
        } catch {
            self.onError(error)
        }
    }
    
    public func downloadUpdate(version: String? = nil) async {
        do {
            let releases = try await loadReleases()
            var releaseToInstall: Release? = nil
            
            if let version {
                releaseToInstall = releases.filter { rel in
                    rel.tag_name.description == version
                }.first
            }
            if releaseToInstall  == nil {
                let currentVersion = Bundle.main.version
                
                releaseToInstall = releases.findViableUpdate(appVersion: currentVersion, repo: repository)
            }
            if let releaseToInstall {
                try await download(release: releaseToInstall)
            }
        } catch {
            self.onError(error)
        }
    }
    
    
    // MARK: - Private Methods
    
    private func download(release: Release) async throws {
        if let asset = release.viableAsset(forRepo: repository) {
            let downloadsDirUrl = try FileManager.default.url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileUrl = downloadsDirUrl.appendingPathComponent(asset.name, conformingTo: .fileURL)
            let data = try await download(asset: asset)
            
            try data.write(to: fileUrl, options: .noFileProtection)
            showInFinder(url: fileUrl)
        }
    }
    
    func showInFinder(url: URL) {
        if url.hasDirectoryPath {
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.path)
        } else {
            NSWorkspace.shared.activateFileViewerSelecting([url])
        }
    }
    
    private func download(asset: Asset) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: asset.browser_download_url)
        
        return data
    }
    
    private func loadReleases() async throws -> [Release] {
        let url = URL(string: "https://api.github.com/repos/\(owner)/\(repository)/releases")!
        
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        let releases = try JSONDecoder().decode([Release].self, from: data)
        
        return releases
    }
    
    private func startOrStopScheduler() {
        if backgroundCheck, let _ = scheduler {
            return
        }
        
        if !backgroundCheck, let scheduler {
            scheduler.invalidate()
            self.scheduler = nil
        }
        
        if backgroundCheck && self.scheduler == nil {
            self.scheduler = Timer
                .scheduledTimer(
                    withTimeInterval: .days(1),
                    repeats: true,
                    block: checkUpdateAvailable(_:))
            self.checkUpdateAvailable(self.scheduler)
        }
    }
    
    private func checkUpdateAvailable(_ : Timer?) {
        Task {
            await checkUpdate()
        }
    }
}

public enum HawkUpdaterError: Error, LocalizedError {
    case invalidContentType(contentType: String)
    case archiveCorrupted
    
    public var errorDescription: String? {
        switch self {
        case .invalidContentType(let contentType):
            return NSLocalizedString("Invalid data received ('\(contentType)')", comment: "HawkUpdaterError")
        case .archiveCorrupted:
            return NSLocalizedString("Archive is corrupt.", comment: "HawkUpdaterError")
        }
    }
}

private extension Array where Element == Release {
    func findViableUpdate(appVersion: Version, repo: String) -> Release? {
        guard
            let latestRelease = self.sorted().last
        else {
            return nil
        }
        guard
            appVersion < latestRelease.tag_name
        else {
            return nil
        }
        return latestRelease
    }
    
    func findViableUpdateVersion(appVersion: Version, repo: String) -> String? {
        return findViableUpdate(appVersion: appVersion, repo: repo)?.tag_name.description
    }
}

private enum ContentType: Decodable {
    init(from decoder: Decoder) throws {
        let contentType = try decoder.singleValueContainer().decode(String.self)
        
        switch contentType  {
        case "application/x-bzip2", "application/x-xz", "application/x-gzip":
            self = .tar
        case "application/zip":
            self = .zip
        default:
            throw HawkUpdaterError.invalidContentType(contentType: contentType)
        }
    }

    case zip
    case tar
}

private struct Asset: Decodable {
    let name: String
    let browser_download_url: URL
    let content_type: ContentType
}

private struct Release: Decodable {
    let tag_name: Version
    let prerelease: Bool
    
    let assets: [Asset]

    func viableAsset(forRepo repo: String) -> Asset? {
        return assets.first(where: { (asset) -> Bool in
            let prefix = "\(repo.lowercased())-\(tag_name)"
            let name = (asset.name as NSString).deletingPathExtension.lowercased()

            switch (name, asset.content_type) {
            case ("\(prefix).tar", .tar):
                return true
            case (prefix, _):
                return true
            default:
                return false
            }
        })
    }
}

extension Release: Comparable {
    static func < (lhs: Release, rhs: Release) -> Bool {
        return lhs.tag_name < rhs.tag_name
    }

    static func == (lhs: Release, rhs: Release) -> Bool {
        return lhs.tag_name == rhs.tag_name
    }
}
