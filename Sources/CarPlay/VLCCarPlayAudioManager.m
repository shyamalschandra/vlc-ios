/*****************************************************************************
 * VLCCarPlayAudioManager.m
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2024 VideoLAN. All rights reserved.
 * $Id$
 *
 * Author: Auto-generated feature enhancement
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

#import "VLCCarPlayAudioManager.h"
#import "VLCPlaybackService.h"
#import <AVFoundation/AVFoundation.h>

@implementation VLCCarPlayAudioManager

+ (instancetype)sharedManager
{
    static VLCCarPlayAudioManager *sharedInstance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[VLCCarPlayAudioManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentAudioMode = VLCCarPlayAudioModeNormal;
        _voiceBoostEnabled = NO;
        _voiceBoostLevel = 0.5;
        
        // Load saved preferences
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _currentAudioMode = (VLCCarPlayAudioMode)[defaults integerForKey:@"VLCCarPlayAudioMode"];
        _voiceBoostEnabled = [defaults boolForKey:@"VLCCarPlayVoiceBoostEnabled"];
        _voiceBoostLevel = [defaults floatForKey:@"VLCCarPlayVoiceBoostLevel"];
    }
    return self;
}

- (void)applyAudioMode:(VLCCarPlayAudioMode)mode
{
    _currentAudioMode = mode;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:mode forKey:@"VLCCarPlayAudioMode"];
    [defaults synchronize];
    
    [self applyAudioSettingsToPlaybackService];
}

- (void)setVoiceBoostEnabled:(BOOL)enabled withLevel:(CGFloat)level
{
    _voiceBoostEnabled = enabled;
    _voiceBoostLevel = MAX(0.0, MIN(1.0, level));
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:enabled forKey:@"VLCCarPlayVoiceBoostEnabled"];
    [defaults setFloat:_voiceBoostLevel forKey:@"VLCCarPlayVoiceBoostLevel"];
    [defaults synchronize];
    
    [self applyAudioSettingsToPlaybackService];
}

- (void)applyAudioSettingsToPlaybackService
{
    VLCPlaybackService *playbackService = [VLCPlaybackService sharedInstance];
    
    // Get number of bands available
    unsigned int numberOfBands = [playbackService numberOfBands];
    
    switch (_currentAudioMode) {
        case VLCCarPlayAudioModeVoice: {
            // Boost mid frequencies for voice clarity (300Hz - 3400Hz)
            for (unsigned int i = 0; i < numberOfBands; i++) {
                CGFloat frequency = [playbackService frequencyOfBandAtIndex:i];
                CGFloat amplification = 0.0;
                
                // Boost frequencies in voice range
                if (frequency >= 300 && frequency <= 3400) {
                    amplification = 6.0 + (_voiceBoostEnabled ? _voiceBoostLevel * 6.0 : 0.0);
                } else if (frequency < 200 || frequency > 4000) {
                    // Reduce low and high frequencies
                    amplification = -3.0;
                }
                
                [playbackService setAmplification:amplification forBand:i];
            }
            playbackService.preAmplification = 2.0;
            break;
        }
            
        case VLCCarPlayAudioModeMusic: {
            // Enhanced music profile with balanced EQ
            for (unsigned int i = 0; i < numberOfBands; i++) {
                CGFloat frequency = [playbackService frequencyOfBandAtIndex:i];
                CGFloat amplification = 0.0;
                
                // Gentle boost for bass and treble
                if (frequency < 200) {
                    amplification = 3.0; // Bass boost
                } else if (frequency > 8000) {
                    amplification = 2.0; // Treble boost
                }
                
                [playbackService setAmplification:amplification forBand:i];
            }
            playbackService.preAmplification = 1.0;
            break;
        }
            
        case VLCCarPlayAudioModePodcast: {
            // Optimize for spoken content
            for (unsigned int i = 0; i < numberOfBands; i++) {
                CGFloat frequency = [playbackService frequencyOfBandAtIndex:i];
                CGFloat amplification = 0.0;
                
                // Boost voice frequencies, reduce noise
                if (frequency >= 300 && frequency <= 3400) {
                    amplification = 4.0;
                } else if (frequency < 100 || frequency > 5000) {
                    amplification = -4.0; // Reduce background noise
                }
                
                [playbackService setAmplification:amplification forBand:i];
            }
            playbackService.preAmplification = 1.5;
            break;
        }
            
        case VLCCarPlayAudioModeNormal:
        default: {
            // Reset all bands to zero
            for (unsigned int i = 0; i < numberOfBands; i++) {
                [playbackService setAmplification:0.0 forBand:i];
            }
            playbackService.preAmplification = 0.0;
            break;
        }
    }
    
    // Apply additional voice boost if enabled
    if (_voiceBoostEnabled && _currentAudioMode != VLCCarPlayAudioModeNormal) {
        for (unsigned int i = 0; i < numberOfBands; i++) {
            CGFloat frequency = [playbackService frequencyOfBandAtIndex:i];
            
            // Additional boost for voice frequencies
            if (frequency >= 500 && frequency <= 3000) {
                CGFloat currentAmplification = [playbackService amplificationOfBand:i];
                [playbackService setAmplification:currentAmplification + (_voiceBoostLevel * 4.0) forBand:i];
            }
        }
    }
}

@end

