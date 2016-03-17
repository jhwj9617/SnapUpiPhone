//
//  SelectBusViewController.m
//  SnapUpiPhone
//
//  Created by WEI JOON JOSEPH HO on 2016-03-11.
//  Copyright © 2016 Cryptic Android. All rights reserved.
//

#import "SelectBusViewController.h"

@implementation SelectBusViewController

BusOrigin *selectedBusOriginToUploadAsset;

- (void) viewDidLoad {
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.tabBarController.tabBar setHidden:YES];
    [self.uploadButton setEnabled:false];
    [self loadBusOriginList];
    [self renderTableView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)renderTableView {
    [self.tableView setDelegate:self];
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setRowHeight:70];
    [self.tableView setDataSource:busOriginList];
    [self.tableView reloadData];
}

- (void) loadBusOriginList {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent: @"BusOriginList.txt"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath] && [NSKeyedUnarchiver unarchiveObjectWithFile:filePath] != nil) {
        busOriginList = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } else {
        busOriginList = [[BusOriginList alloc] init];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedBusOriginToUploadAsset = [busOriginList.busOrigins objectAtIndex:indexPath.row];
    [self.uploadButton setEnabled:true];
}

- (IBAction)uploadButtonPressed:(id)sender {
    NSLog(@"Upload Button Pressed");
    self.didUpload = true;
    [self performSegueWithIdentifier:@"SelectBusToCamera" sender:self];
}

@end
