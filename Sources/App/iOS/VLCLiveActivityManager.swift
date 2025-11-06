/*****************************************************************************
 * VLCLiveActivityManager.swift
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
import ActivityKit
import WidgetKit

@available(iOS 16.1, *)
@objc(VLCLiveActivityManager)
public class VLCLiveActivityManager: NSObject {
    
    @objc public static let shared = VLCLiveActivityManager()
    
    private var currentActivity: Activity<VLCPlaybackAttributes>?
    
    private override init() {
        super.init()
    }
    
    @objc(startPlaybackActivityWithTitle:artist:thumbnail:duration:)
    func startPlaybackActivity(title: String, artist: String?, thumbnail: String?, duration: TimeInterval) {
        Task { @MainActor in
            guard ActivityAuthorizationInfo().areActivitiesEnabled else {
                return
            }
            
            let attributes = VLCPlaybackAttributes(
                title: title,
                artist: artist ?? ""
            )
            
            let initialState = VLCPlaybackAttributes.ContentState(
                progress: 0.0,
                isPlaying: true,
                elapsedTime: 0.0,
                remainingTime: duration
            )
            
            do {
                let activity = try Activity<VLCPlaybackAttributes>.request(
                    attributes: attributes,
                    contentState: initialState,
                    pushType: nil
                )
                self.currentActivity = activity
            } catch {
                print("Failed to start Live Activity: \(error)")
            }
        }
    }
    
    @objc(updatePlaybackActivityWithProgress:isPlaying:elapsedTime:remainingTime:)
    func updatePlaybackActivity(progress: Double, isPlaying: Bool, elapsedTime: TimeInterval, remainingTime: TimeInterval) {
        Task { @MainActor in
            guard let activity = self.currentActivity else { return }
            
            let updatedState = VLCPlaybackAttributes.ContentState(
                progress: progress,
                isPlaying: isPlaying,
                elapsedTime: elapsedTime,
                remainingTime: remainingTime
            )
            
            await activity.update(using: updatedState)
        }
    }
    
    @objc func endPlaybackActivity() {
        Task { @MainActor in
            guard let activity = self.currentActivity else { return }
            
            await activity.end(dismissalPolicy: .immediate)
            
            self.currentActivity = nil
        }
    }
}

@available(iOS 16.1, *)
struct VLCPlaybackAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var progress: Double
        var isPlaying: Bool
        var elapsedTime: TimeInterval
        var remainingTime: TimeInterval
    }
    
    var title: String
    var artist: String
}

