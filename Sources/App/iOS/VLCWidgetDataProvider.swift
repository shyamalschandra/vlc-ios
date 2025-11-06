/*****************************************************************************
 * VLCWidgetDataProvider.swift
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2024 VideoLAN. All rights reserved.
 * $Id$
 *
 * Author: Auto-generated feature enhancement
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation
import WidgetKit
import UIKit

@available(iOS 14.0, *)
@objc(VLCWidgetDataProvider)
public class VLCWidgetDataProvider: NSObject {
    
    @objc public static let shared = VLCWidgetDataProvider()
    
    private override init() {
        super.init()
    }
    
    private let appGroupIdentifier = "group.sapanamicro"
    
    @objc public class RecentlyPlayedItem: NSObject, Codable {
        @objc public let title: String
        @objc public let artist: String?
        @objc public let thumbnailURL: String?
        @objc public let mediaURL: String
        @objc public let lastPlayedDate: Date
        
        @objc public init(title: String, artist: String?, thumbnailURL: String?, mediaURL: String, lastPlayedDate: Date) {
            self.title = title
            self.artist = artist
            self.thumbnailURL = thumbnailURL
            self.mediaURL = mediaURL
            self.lastPlayedDate = lastPlayedDate
            super.init()
        }
    }
    
    @objc func saveRecentlyPlayed(_ items: [RecentlyPlayedItem]) {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier) else {
            return
        }
        
        let fileURL = containerURL.appendingPathComponent("RecentlyPlayed.json")
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(items)
            try data.write(to: fileURL)
            
            // Notify widgets to reload
            if #available(iOS 14.0, *) {
                WidgetCenter.shared.reloadAllTimelines()
            }
        } catch {
            print("Failed to save recently played items: \(error)")
        }
    }
    
    @objc func getRecentlyPlayed() -> [RecentlyPlayedItem] {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier) else {
            return []
        }
        
        let fileURL = containerURL.appendingPathComponent("RecentlyPlayed.json")
        
        guard let data = try? Data(contentsOf: fileURL) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([RecentlyPlayedItem].self, from: data)
        } catch {
            print("Failed to load recently played items: \(error)")
            return []
        }
    }
    
    @objc func updateFromPlaybackService(_ playbackService: Any) {
        // Use runtime to access VLCPlaybackService properties via KVC
        // This works because VLCPlaybackService is exposed through the bridging header
        guard let playbackServiceObj = playbackService as? NSObject else {
            return
        }
        
        // Get currentlyPlayingMedia using KVC (bridged from Objective-C)
        // VLCPlaybackService.currentlyPlayingMedia returns VLCMedia
        guard let currentMedia = playbackServiceObj.value(forKey: "currentlyPlayingMedia") as? NSObject else {
            return
        }
        
        var recentlyPlayed = getRecentlyPlayed()
        
        // Get metadata using KVC (bridged from Objective-C)
        // VLCPlaybackService.metadata returns VLCMetaData
        guard let metadata = playbackServiceObj.value(forKey: "metadata") as? NSObject else {
            return
        }
        
        // Extract properties using KVC
        let title = (metadata.value(forKey: "title") as? String) ?? "Unknown"
        let artist = metadata.value(forKey: "artist") as? String
        
        // Get media URL - VLCMedia has a url property of type NSURL
        var mediaURL = ""
        if let url = currentMedia.value(forKey: "url") as? NSURL {
            mediaURL = url.absoluteString ?? ""
        } else if let urlString = currentMedia.value(forKeyPath: "url.absoluteString") as? String {
            mediaURL = urlString
        } else if let urlString = currentMedia.value(forKey: "url") as? String {
            mediaURL = urlString
        }
        
        // Only add if we have a valid URL
        guard !mediaURL.isEmpty else {
            return
        }
        
        let item = RecentlyPlayedItem(
            title: title,
            artist: artist,
            thumbnailURL: nil,
            mediaURL: mediaURL,
            lastPlayedDate: Date()
        )
        
        // Remove duplicates and add to front
        recentlyPlayed.removeAll { $0.mediaURL == item.mediaURL }
        recentlyPlayed.insert(item, at: 0)
        
        // Keep only last 10 items
        if recentlyPlayed.count > 10 {
            recentlyPlayed = Array(recentlyPlayed.prefix(10))
        }
        
        saveRecentlyPlayed(recentlyPlayed)
    }
}

