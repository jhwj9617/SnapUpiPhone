//
//  SelectBusViewController.m
//  SnapUpiPhone
//
//  Created by WEI JOON JOSEPH HO on 2016-03-11.
//  Copyright © 2016 Cryptic Android. All rights reserved.
//

#import "SelectBusViewController.h"

@implementation SelectBusViewController

- (void) viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

@end
