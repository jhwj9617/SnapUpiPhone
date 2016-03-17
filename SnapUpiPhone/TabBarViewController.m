//
//  TabBarViewController.m
//  SnapUpiPhone
//
//  Created by WEI JOON JOSEPH HO on 2016-03-10.
//  Copyright © 2016 Cryptic Android. All rights reserved.
//

#import "TabBarViewController.h"

@implementation TabBarViewController
Reachability* reachability;
UIView *notificationView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setDelegate:self];
    Reachability *reachabilityInfo;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNetworkChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:reachabilityInfo];
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) handleNetworkChanged:(NSNotification *)notice {
    [notificationView removeFromSuperview];
    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    notificationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.height, 20)];
    notificationView.backgroundColor = [UIColor redColor];
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if(remoteHostStatus == NotReachable) {
        NSLog(@"connectionLost");
        [mainWindow addSubview: notificationView];
    } else {
        NSLog(@"connectionFound");
    }
}

@end
