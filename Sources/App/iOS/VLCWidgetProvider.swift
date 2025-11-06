/*****************************************************************************
 * VLCWidgetProvider.swift
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
import SwiftUI

@available(iOS 14.0, *)
struct VLCRecentlyPlayedWidget: Widget {
    let kind: String = "VLCRecentlyPlayedWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: VLCWidgetTimelineProvider()) { entry in
            VLCWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Recently Played")
        .description("Quick access to your recently played media")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@available(iOS 14.0, *)
struct VLCWidgetEntry: TimelineEntry {
    let date: Date
    let items: [VLCWidgetDataProvider.RecentlyPlayedItem]
}

@available(iOS 14.0, *)
struct VLCWidgetTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> VLCWidgetEntry {
        VLCWidgetEntry(
            date: Date(),
            items: [
                VLCWidgetDataProvider.RecentlyPlayedItem(
                    title: "Sample Video",
                    artist: "Sample Artist",
                    thumbnailURL: nil,
                    mediaURL: "",
                    lastPlayedDate: Date()
                )
            ]
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (VLCWidgetEntry) -> Void) {
        let entry = VLCWidgetEntry(
            date: Date(),
            items: VLCWidgetDataProvider.shared.getRecentlyPlayed()
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<VLCWidgetEntry>) -> Void) {
        let currentDate = Date()
        let entry = VLCWidgetEntry(
            date: currentDate,
            items: VLCWidgetDataProvider.shared.getRecentlyPlayed()
        )
        
        // Refresh every hour
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

@available(iOS 14.0, *)
struct VLCWidgetEntryView: View {
    var entry: VLCWidgetEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recently Played")
                .font(.headline)
                .foregroundColor(.primary)
            
            if entry.items.isEmpty {
                Text("No recent playback")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                ForEach(entry.items.prefix(3), id: \.mediaURL) { item in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.title)
                                .font(.subheadline)
                                .lineLimit(1)
                            if let artist = item.artist {
                                Text(artist)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding()
    }
}

