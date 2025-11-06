# Build and Test Instructions

## Prerequisites

1. **Xcode**: Ensure Xcode is properly installed and configured
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   ```

2. **CocoaPods**: Already installed via rbenv (Ruby 3.3.0)
   ```bash
   eval "$(rbenv init - zsh)"
   pod --version  # Should show 1.16.2
   ```

3. **Dependencies**: All pods are installed in `Pods/` directory

## New Files Added to Project

### CarPlay Enhancements
- `Sources/CarPlay/VLCCarPlayAudioManager.h`
- `Sources/CarPlay/VLCCarPlayAudioManager.m`
- ✅ Already added to Xcode project

### iOS Features
- `Sources/App/iOS/VLCFocusModeManager.swift`
- `Sources/App/iOS/VLCWidgetDataProvider.swift`
- `Sources/App/iOS/VLCWidgetProvider.swift`
- `Sources/App/iOS/VLCLiveActivityManager.swift`
- ⚠️ **Need to be added to Xcode project manually**

### Enhanced APIs
- `Sources/Playback/Control/VLCPlaybackService.h` - Added equalizer methods

## Building in Xcode

1. **Open Workspace**
   ```bash
   open VLC.xcworkspace
   ```

2. **Add New Files** (if not already added):
   - Right-click on `Sources/App/iOS` group
   - Select "Add Files to VLC-iOS..."
   - Add the 4 new Swift files:
     - VLCFocusModeManager.swift
     - VLCWidgetDataProvider.swift
     - VLCWidgetProvider.swift
     - VLCLiveActivityManager.swift
   - Ensure "VLC-iOS" target is checked

3. **Select Scheme**: `VLC-iOS`

4. **Select Simulator**: iPhone 15 Pro (or any iOS 15+ simulator)

5. **Build**: Press ⌘B or Product → Build

6. **Run**: Press ⌘R or Product → Run

## Expected Build Issues & Fixes

### Issue 1: Missing Bridging Header
**Error**: `'VLC-Swift.h' file not found` or similar

**Fix**: Ensure the bridging header is configured:
- Go to Build Settings → Swift Compiler - General
- Verify "Objective-C Bridging Header" is set correctly

### Issue 2: Live Activity API
**Error**: `Activity` or `ActivityKit` not available

**Fix**: Live Activities require iOS 16.1+. Ensure:
- Deployment target is iOS 12.0+ (for main app)
- Code is properly guarded with `@available(iOS 16.1, *)`

### Issue 3: Widget Extension Missing
**Error**: Widget-related code fails

**Fix**: Widget extension target needs to be created:
- File → New → Target
- Select "Widget Extension"
- Configure with App Group: `group.sapanamicro`

### Issue 4: App Groups Configuration
**Error**: App group access fails

**Fix**: Verify entitlements:
- Check `Resources/iOS/VLC.entitlements`
- Ensure `com.apple.security.application-groups` includes `group.sapanamicro`
- Verify in Xcode project settings → Signing & Capabilities

## Testing Features

### CarPlay Audio Enhancements
1. Connect iPhone to CarPlay unit (or use CarPlay simulator)
2. Open VLC app
3. Play audio content
4. Audio should be optimized for CarPlay
5. Test voice boost and different audio modes

### Focus Mode Integration
1. Set up Focus mode in iOS Settings
2. Configure VLC library filters for Focus mode
3. Open VLC app
4. Verify only allowed content categories are shown

### Widgets (Requires Extension)
1. Long-press on Home Screen
2. Tap "+" to add widget
3. Search for "VLC"
4. Add "Recently Played" widget
5. Verify it shows recently played content

### Live Activities (iOS 16.1+)
1. Start playback in VLC
2. Check Dynamic Island (iPhone 14 Pro+) or Lock Screen
3. Verify playback controls appear
4. Test pause/play from Live Activity

## Troubleshooting

### Build Errors
1. Clean build folder: Product → Clean Build Folder (⇧⌘K)
2. Delete DerivedData: 
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
3. Reinstall pods:
   ```bash
   pod deintegrate
   pod install
   ```

### Runtime Errors
1. Check console logs in Xcode
2. Verify all entitlements are properly configured
3. Ensure app groups match between app and extensions

## Next Steps for Full Implementation

1. **Create Widget Extension Target**
   - Add Widget Extension to project
   - Configure Info.plist
   - Link widget provider code

2. **Complete Live Activities**
   - Add ActivityKit framework
   - Test on iOS 16.1+ device
   - Verify Dynamic Island integration

3. **Add UI Controls**
   - CarPlay audio mode selector
   - Focus mode configuration UI
   - Widget settings

4. **Testing**
   - Unit tests for new features
   - Integration tests
   - UI tests for widgets

5. **iCloud Sync**
   - Configure CloudKit containers
   - Implement sync service
   - Test cross-device sync

