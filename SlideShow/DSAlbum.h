//
//  DSAlbum.h
//  SlideShow
//
//  Created by Jeremy Templier on 14/06/14.
//  Copyright (c) 2014 DispatchSync. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSAlbum : NSObject
+ (NSArray *)albumsToDisplay;
+ (void)addAlbumToDisplay:(NSString *)albumID;
+ (void)removeAlbumToDisplay:(NSString *)albumID;
+ (void)getAlbumsWithCompletion:(void(^)(NSArray * albums))completion;
+ (void)getRandomPhoto:(void(^)(UIImage * photo))completion;
@end
