//
//  TodayViewController.m
//  DSPhotoWidget
//
//  Created by Jeremy Templier on 16/06/14.
//  Copyright (c) 2014 DispatchSync. All rights reserved.
//

#import <NotificationCenter/NotificationCenter.h>
#import "TodayViewController.h"
#import "DSAlbum.h"

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UILabel *debugLabel;
@property (strong, nonatomic) UIImage *photo;
@end

@implementation TodayViewController


- (void)awakeFromNib
{
    [super awakeFromNib];
    __weak __typeof__(self) weakSelf = self;
    [DSAlbum getRandomPhoto:^(UIImage *photo) {
        weakSelf.photo = photo;
        weakSelf.photoImageView.image = weakSelf.photo;
        CGSize size = weakSelf.preferredContentSize;
        size.height = 100;
        [weakSelf setPreferredContentSize:size];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)tapGestureHandler:(UITapGestureRecognizer *)gesture
{
    CGSize preferredContentSize = self.preferredContentSize;
    preferredContentSize.height = preferredContentSize.height >= 200 ? 100 : 300;
    [self setPreferredContentSize:preferredContentSize];
}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    completionHandler(NCUpdateResultNewData);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
}

@end
