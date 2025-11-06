/*****************************************************************************
 * VLCCarPlayAudioManager.h
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2024 VideoLAN. All rights reserved.
 * $Id$
 *
 * Author: Auto-generated feature enhancement
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VLCCarPlayAudioMode) {
    VLCCarPlayAudioModeNormal,
    VLCCarPlayAudioModeVoice,
    VLCCarPlayAudioModeMusic,
    VLCCarPlayAudioModePodcast
};

@interface VLCCarPlayAudioManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, assign) VLCCarPlayAudioMode currentAudioMode;
@property (nonatomic, assign) BOOL voiceBoostEnabled;
@property (nonatomic, assign) CGFloat voiceBoostLevel; // 0.0 to 1.0

- (void)applyAudioMode:(VLCCarPlayAudioMode)mode;
- (void)setVoiceBoostEnabled:(BOOL)enabled withLevel:(CGFloat)level;
- (void)applyAudioSettingsToPlaybackService;

@end

NS_ASSUME_NONNULL_END

