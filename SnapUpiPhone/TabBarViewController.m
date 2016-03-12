//
//  TabBarViewController.m
//  SnapUpiPhone
//
//  Created by WEI JOON JOSEPH HO on 2016-03-10.
//  Copyright © 2016 Cryptic Android. All rights reserved.
//

#import "TabBarViewController.h"

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setDelegate:self];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


//- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    if (viewController == [tabBarController.viewControllers objectAtIndex:1] )
//    {
//        // Enable all but the last tab.
//        [self performSegueWithIdentifier:@"TabBarToCamera" sender:self];
//        return NO;
//    }
//    
//    return YES;
//}

@end
