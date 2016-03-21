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
BusOriginList * busOriginList;
BusOrigin *selectedBusOrigin;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBusOriginList];
    self.tableView.contentInset = UIEdgeInsetsZero;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self renderTableView];
}

- (void)renderTableView {
    [self.tableView setDelegate:self];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setRowHeight:70];
    [self.tableView setDataSource:busOriginList];
    [self.tableView reloadData];
}

- (IBAction)addBusDialog:(id)sender {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        UIAlertController *addBusAlert = [UIAlertController alertControllerWithTitle:@"Add New Bus"
                                                                       message:@"Enter a descriptive bus name.\n(e.g. iPhone to HomePC)"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [addBusAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        __block UITextField *inputName;
        [addBusAlert addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self addBus:inputName.text];
        }]];
        [addBusAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.text = [[UIDevice currentDevice] name];
            [textField becomeFirstResponder];
            inputName = textField;
        }];
        [self presentViewController:addBusAlert animated:YES completion:nil];
    }
    else {
        UIAlertController *noInternetAlert = [InterfaceUtilities createAlertDialogWithTitle:@"Adding New Bus Unavailable" Message:@"You need to be connected to your network or Wi-Fi to add a new bus."];
        [self presentViewController:noInternetAlert animated:YES completion:nil];
    }
}

- (void) addBus:(NSString*) busName {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString* encodedBusName = [busName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", @"http://snapup.apphb.com/Buses/Create?mobileId=1&name=", encodedBusName];
    NSLog(@"%@", urlString);
    
    __block NSDictionary *json;
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@", strData);
                if(data != nil) {
                    json = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
                    
                    if ([[json objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                        BusOrigin *newBusOrigin = [[BusOrigin alloc] init];
                        newBusOrigin.name = busName;
                        newBusOrigin.code = [json objectForKey:@"code"];
                        [busOriginList addBusOrigin:newBusOrigin];
                        [self saveBusOriginList];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                    }
                }
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }] resume];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedBusOrigin = [busOriginList.busOrigins objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"BusesToBusOriginProperties" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"BusesToBusOriginProperties"]) {
        BusOriginPropertiesViewController *busOriginPropertiesVC = [segue destinationViewController];
        [busOriginPropertiesVC setBusOrigin:selectedBusOrigin];
    }
}

- (IBAction)unwindFromModalViewController:(UIStoryboardSegue *)segue {
    if ([[segue identifier] isEqualToString:@"BusOriginPropertiesToBuses"]) {
        BusOriginPropertiesViewController *busOriginPropertiesVC = segue.sourceViewController;
        if (busOriginPropertiesVC.didDelete) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self deleteSelectedBusOrigin];
            });
        }
    }
}

- (void) deleteSelectedBusOrigin {
    [busOriginList deleteBusOrigin:selectedBusOrigin];
    [self saveBusOriginList];
}

@end
