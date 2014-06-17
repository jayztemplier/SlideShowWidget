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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)tapGestureHandler:(UITapGestureRecognizer *)gesture
{
    CGSize currentSize = self.preferredContentSize;
    if (currentSize.height >= 200) {
        [self setPreferredContentSize:CGSizeMake(320, 100)];
    } else {
        [self setPreferredContentSize:CGSizeMake(320, 200)];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setPreferredContentSize:CGSizeMake(320, 100)];
    __weak __typeof__(self) weakSelf = self;
    [DSAlbum getRandomPhoto:^(UIImage *photo) {
        weakSelf.photo = photo;
        weakSelf.photoImageView.image = weakSelf.photo;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    _photoImageView.image = _photo;
    completionHandler(NCUpdateResultNewData);
}

@end
