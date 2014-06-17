//
//  DSSettingsViewController.m
//  SlideShow
//
//  Created by Jeremy Templier on 14/06/14.
//  Copyright (c) 2014 DispatchSync. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "DSSettingsViewController.h"
#import "DSAlbum.h"

static NSString * const CellIdentifier = @"AlbumCell";


@interface DSSettingsViewController ()
//@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, copy) NSArray *albums;
@end

@implementation DSSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self refresh];
}

- (void)refresh
{
    __weak DSSettingsViewController *weakSelf = self;
    [self getAlbumsWithCompletion:^(NSArray *albums) {
        _albums = albums;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _albums ? [_albums count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *title = @"";
    UIImage *image = nil;
    UITableViewCellAccessoryType accessoryType = UITableViewCellAccessoryNone;
    
    if (_albums && indexPath.row < [_albums count]) {
        title = _albums[indexPath.row][@"name"];
        image = _albums[indexPath.row][@"image"];
        accessoryType = [_albums[indexPath.row][@"selected"] boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = title;
    cell.imageView.image = image;
    cell.accessoryType = accessoryType;
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_albums  && indexPath.row < [_albums count]) {
        NSDictionary *album = _albums[indexPath.row];
        if ([album[@"selected"] boolValue]) {
            [DSAlbum removeAlbumToDisplay:album[@"id"]];
        } else {
            [DSAlbum addAlbumToDisplay:album[@"id"]];
        }
        [self refresh];
    }
}

- (void)getAlbumsWithCompletion:(void(^)(NSArray * albums))completion
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

@end
