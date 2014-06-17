//
//  DSAlbum.m
//  SlideShow
//
//  Created by Jeremy Templier on 14/06/14.
//  Copyright (c) 2014 DispatchSync. All rights reserved.
//

#import "DSAlbum.h"

static NSString * const kAlbumsToDisplay = @"albums_to_display";

@implementation DSAlbum

+ (NSArray *)albumsToDisplay
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray * result = [userDefaults objectForKey:kAlbumsToDisplay];
    return result ? result : @[];
}

+ (void)addAlbumToDisplay:(NSString *)albumID
{
    NSMutableArray *albumstoDisplay = [[self albumsToDisplay] mutableCopy];
    if (![albumstoDisplay containsObject:albumID]) {
        [albumstoDisplay addObject:albumID];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:albumstoDisplay forKey:kAlbumsToDisplay];
        [userDefaults synchronize];
    }
}

+ (void)removeAlbumToDisplay:(NSString *)albumID
{
    NSMutableArray *albumstoDisplay = [[self albumsToDisplay] mutableCopy];
    if ([albumstoDisplay containsObject:albumID]) {
        [albumstoDisplay removeObject:albumID];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:albumstoDisplay forKey:kAlbumsToDisplay];
        [userDefaults synchronize];
    }
}

@end
