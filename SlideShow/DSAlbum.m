//
//  DSAlbum.m
//  SlideShow
//
//  Created by Jeremy Templier on 14/06/14.
//  Copyright (c) 2014 DispatchSync. All rights reserved.
//

#import "DSAlbum.h"
#import <AssetsLibrary/AssetsLibrary.h>

static NSString * const kAlbumsToDisplay = @"albums_to_display";
static NSString * const kSharedSuiteName = @"group.com.dispatchsync.slideshow";
static NSInteger testInteger  = 0;
@implementation DSAlbum

+ (NSArray *)albumsToDisplay
{
    NSUserDefaults *settings = [[NSUserDefaults alloc] initWithSuiteName:kSharedSuiteName];
    NSArray * result = [settings objectForKey:kAlbumsToDisplay];
    return result ? result : @[];
}

+ (void)addAlbumToDisplay:(NSString *)albumID
{
    testInteger++;
    NSMutableArray *albumstoDisplay = [[self albumsToDisplay] mutableCopy];
    if (![albumstoDisplay containsObject:albumID]) {
        [albumstoDisplay addObject:albumID];
        
        NSUserDefaults *settings = [[NSUserDefaults alloc] initWithSuiteName:kSharedSuiteName];
        [settings setObject:albumstoDisplay forKey:kAlbumsToDisplay];
        [settings synchronize];
    }
}

+ (void)removeAlbumToDisplay:(NSString *)albumID
{
    NSMutableArray *albumstoDisplay = [[self albumsToDisplay] mutableCopy];
    if ([albumstoDisplay containsObject:albumID]) {
        [albumstoDisplay removeObject:albumID];
        
        NSUserDefaults *settings = [[NSUserDefaults alloc] initWithSuiteName:kSharedSuiteName];
        [settings setObject:albumstoDisplay forKey:kAlbumsToDisplay];
        [settings synchronize];
    }
}

+ (void)getAlbumsWithCompletion:(void(^)(NSArray * albums))completion
{
    NSArray *albumIDs = [DSAlbum albumsToDisplay];
    NSDictionary *albumsToSync ;
    if (!albumsToSync) {
        albumsToSync = @{};
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        if (group) {
            NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
            NSString *propertyID = [group valueForProperty:ALAssetsGroupPropertyPersistentID];
            UIImage *image = [UIImage imageWithCGImage:[group posterImage]];
            [array addObject:@{@"name": name,
                               @"id": propertyID,
                               @"image": image,
                               @"selected" : [NSNumber numberWithBool:[albumIDs containsObject:propertyID]]}];
        } else {
            completion(array);
        }
    } failureBlock: ^(NSError *error) {
        NSLog(@"No groups");
    }];
}

+ (void)getRandomPhoto:(void(^)(UIImage * photo))completion
{
    NSArray *albumIDs = [self albumsToDisplay];
    NSMutableArray *photos = [NSMutableArray array];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        if (group) {
            if ([albumIDs containsObject:[group valueForProperty:ALAssetsGroupPropertyPersistentID]]) {
                [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
                    if (alAsset) {
                        UIImage *image = [UIImage imageWithCGImage:[alAsset thumbnail]];
                        [photos addObject:image];
                    }
                }];
            };
            
            
        } else {
            NSUInteger randomIndex = arc4random_uniform([photos count]);
            UIImage *randomPhoto = nil;
            if (randomIndex < [photos count]) {
                randomPhoto = photos[randomIndex];
            }
            if (completion) {
                completion(randomPhoto);
            }
        }
    } failureBlock: ^(NSError *error) {
        if (completion) {
            completion(nil);
        }
    }];
    
}
@end
