//
//  DSAlbum.h
//  SlideShow
//
//  Created by Jeremy Templier on 14/06/14.
//  Copyright (c) 2014 DispatchSync. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSAlbum : NSObject
+ (NSArray *)albumsToDisplay;
+ (void)addAlbumToDisplay:(NSString *)albumID;
+ (void)removeAlbumToDisplay:(NSString *)albumID;
@end
