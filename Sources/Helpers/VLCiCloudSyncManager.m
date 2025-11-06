/*****************************************************************************
 * VLCiCloudSyncManager.m
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2024 VideoLAN. All rights reserved.
 * $Id$
 *
 * Author: Auto-generated feature enhancement
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

#import "VLCiCloudSyncManager.h"
#import "VLCFavoriteService.h"
#import <CloudKit/CloudKit.h>

NSString *const kVLCiCloudSyncEnabled = @"kVLCiCloudSyncEnabled";
NSString *const kVLCiCloudSyncContainerIdentifier = @"iCloud.sapanamicro";

@implementation VLCiCloudSyncManager

+ (instancetype)sharedManager
{
    static VLCiCloudSyncManager *sharedInstance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[VLCiCloudSyncManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Check if iCloud is available
        if ([self isiCloudAvailable]) {
            // Observe iCloud sync changes
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(iCloudAccountChanged:)
                                                         name:NSUbiquityIdentityDidChangeNotification
                                                       object:nil];
        }
    }
    return self;
}

- (BOOL)isiCloudAvailable
{
    return [[NSFileManager defaultManager] ubiquityIdentityToken] != nil;
}

- (void)enableiCloudSync:(BOOL)enabled
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:enabled forKey:kVLCiCloudSyncEnabled];
    [defaults synchronize];
    
    if (enabled && [self isiCloudAvailable]) {
        [self syncToiCloud];
    }
}

- (BOOL)isiCloudSyncEnabled
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:kVLCiCloudSyncEnabled] && [self isiCloudAvailable];
}

- (void)syncFavorites:(VLCFavoriteService *)favoriteService
{
    if (![self isiCloudSyncEnabled]) {
        return;
    }
    
    // Use NSUbiquitousKeyValueStore for favorites sync
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    
    // Get favorites from favorite service
    NSInteger serverCount = [favoriteService numberOfFavoritedServers];
    NSMutableArray *favoritesArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < serverCount; i++) {
        NSString *serverName = [favoriteService nameOfFavoritedServerAtIndex:i];
        NSInteger favoriteCount = [favoriteService numberOfFavoritesOfServerAtIndex:i];
        
        NSMutableDictionary *serverDict = [NSMutableDictionary dictionary];
        serverDict[@"name"] = serverName;
        serverDict[@"favoriteCount"] = @(favoriteCount);
        
        [favoritesArray addObject:serverDict];
    }
    
    // Store in iCloud
    [store setArray:favoritesArray forKey:@"VLCSyncedFavorites"];
    [store synchronize];
}

- (void)syncPlaylists
{
    if (![self isiCloudSyncEnabled]) {
        return;
    }
    
    // Playlist sync would be implemented here
    // This requires access to the media library service
    // For now, this is a placeholder
}

- (void)syncToiCloud
{
    if (![self isiCloudAvailable]) {
        return;
    }
    
    // Trigger sync of all synced data
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    [store synchronize];
}

- (void)syncFromiCloud
{
    if (![self isiCloudAvailable]) {
        return;
    }
    
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    [store synchronize];
    
    // Merge local and iCloud data
    NSArray *syncedFavorites = [store arrayForKey:@"VLCSyncedFavorites"];
    if (syncedFavorites) {
        // Merge logic would go here
        // This would need to integrate with VLCFavoriteService
    }
}

- (void)iCloudAccountChanged:(NSNotification *)notification
{
    // Handle iCloud account changes
    if (![self isiCloudAvailable]) {
        // iCloud is no longer available
        [self enableiCloudSync:NO];
    } else {
        // New iCloud account, sync data
        [self syncFromiCloud];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

