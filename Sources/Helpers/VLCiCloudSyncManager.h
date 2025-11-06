/*****************************************************************************
 * VLCiCloudSyncManager.h
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

@class VLCFavoriteService;

@interface VLCiCloudSyncManager : NSObject

+ (instancetype)sharedManager;

- (void)enableiCloudSync:(BOOL)enabled;
- (BOOL)isiCloudSyncEnabled;

- (void)syncFavorites:(VLCFavoriteService *)favoriteService;
- (void)syncPlaylists;

- (void)syncToiCloud;
- (void)syncFromiCloud;

@end

NS_ASSUME_NONNULL_END

