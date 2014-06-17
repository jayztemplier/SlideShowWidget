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
    
    
    NSUserDefaults *settings = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.dispatchsync.slideshow"];
    _debugLabel.text = [NSString stringWithFormat:@"%@", [settings objectForKey:@"test"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    NSUserDefaults *settings = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.dispatchsync.slideshow"];
    _debugLabel.text = [NSString stringWithFormat:@"%@", [settings objectForKey:@"test"]];
    _photoImageView.image = _photo;
    completionHandler(NCUpdateResultNewData);
}

@end
