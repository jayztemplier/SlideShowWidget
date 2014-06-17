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
@end

@implementation TodayViewController
static int debugInteger = 0;

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
    _debugLabel.text = [NSString stringWithFormat:@"%d", debugInteger];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encoutered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    debugInteger++;
    _debugLabel.text = [NSString stringWithFormat:@"%d", debugInteger];
    completionHandler(NCUpdateResultNewData);
}

@end
