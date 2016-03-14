//
//  ViewController.m
//  SnapUpiPhone
//
//  Created by WEI JOON JOSEPH HO on 2016-03-09.
//  Copyright © 2016 Cryptic Android. All rights reserved.
//

#import "BusesViewController.h"


@interface BusesViewController () {
    
}

@end

@implementation BusesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBusOriginList];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self renderTableView];
    
    if ([busOriginList.busOrigins lastObject]) {
        BusOrigin *bo = [busOriginList.busOrigins lastObject];
        self.centerLabel.text = bo.name;
    }
}

- (void)renderTableView {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setRowHeight:70];
    [self.tableView setDataSource:busOriginList];
    [self.tableView reloadData];
}

- (IBAction)addBusDialog:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add New Bus" message:@"Enter a bus name or use the default name." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    __block UITextField *inputName;
    [alert addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        BusOrigin *newBusOrigin = [[BusOrigin alloc] init];
        newBusOrigin.name = inputName.text;
        newBusOrigin.code = @"1234abcd";
        [busOriginList addBusOrigin:newBusOrigin];
        [self saveBusOriginList];
        [self.tableView reloadData];
    }]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = [[UIDevice currentDevice] name];
        inputName = textField;
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) saveBusOriginList {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent: @"BusOriginList.txt"];
    [NSKeyedArchiver archiveRootObject:busOriginList toFile:filePath];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
