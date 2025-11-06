/*****************************************************************************
 * VLCFocusModeManager.swift
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
import UserNotifications
import UIKit

@available(iOS 15.0, *)
@objc(VLCFocusModeManager)
public class VLCFocusModeManager: NSObject {
    
    @objc public static let shared = VLCFocusModeManager()
    
    private var mediaLibraryService: MediaLibraryService?
    private var focusModeObserver: NSObjectProtocol?
    
    private override init() {
        super.init()
        setupFocusModeObserver()
    }
    
    @objc func setMediaLibraryService(_ service: MediaLibraryService) {
        mediaLibraryService = service
    }
    
    private func setupFocusModeObserver() {
        if #available(iOS 15.0, *) {
            // Observe Focus mode changes via notification center
            // Note: Focus mode integration requires Intent framework
            // For now, we'll use a simpler approach with UserDefaults
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(applicationDidBecomeActive),
                name: UIApplication.didBecomeActiveNotification,
                object: nil
            )
        }
    }
    
    @objc private func applicationDidBecomeActive() {
        updateFocusModeSettings()
    }
    
    private func updateFocusModeSettings() {
        // Post notification to update UI based on Focus mode
        NotificationCenter.default.post(
            name: NSNotification.Name("VLCDidUpdateFocusMode"),
            object: self
        )
    }
    
    func getFilteredLibraryForCurrentFocus() -> [String]? {
        // Get user-defined library filters for current Focus mode
        let defaults = UserDefaults.standard
        let currentFocus = getCurrentFocusModeIdentifier() ?? "default"
        
        // Return list of allowed media categories or nil for all
        return defaults.array(forKey: "VLCFocusModeLibrary_\(currentFocus)") as? [String]
    }
    
    func shouldShowContent(_ category: String) -> Bool {
        guard let allowedCategories = getFilteredLibraryForCurrentFocus() else {
            // No filter set, show all content
            return true
        }
        
        return allowedCategories.contains(category)
    }
    
    func configureLibraryForFocusMode(_ focusModeIdentifier: String, categories: [String]) {
        let defaults = UserDefaults.standard
        defaults.set(categories, forKey: "VLCFocusModeLibrary_\(focusModeIdentifier)")
        defaults.synchronize()
        
        updateFocusModeSettings()
    }
    
    func getCurrentFocusModeIdentifier() -> String? {
        // For iOS 15+, we would query INFocusStatusCenter
        // For now, return a placeholder that can be extended
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "VLCCurrentFocusModeIdentifier")
    }
    
    func setCurrentFocusModeIdentifier(_ identifier: String) {
        let defaults = UserDefaults.standard
        defaults.set(identifier, forKey: "VLCCurrentFocusModeIdentifier")
        defaults.synchronize()
        updateFocusModeSettings()
    }
    
    deinit {
        if let observer = focusModeObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        NotificationCenter.default.removeObserver(self)
    }
}

