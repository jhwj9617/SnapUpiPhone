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

BusOrigin *selectedBusOrigin;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBusOriginList];
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
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setRowHeight:70];
    [self.tableView setDataSource:busOriginList];
    [self.tableView reloadData];
}

- (IBAction)addBusDialog:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add New Bus"
                                                                   message:@"Enter a descriptive bus name.\n(e.g. iPhone to HomePC)"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    __block UITextField *inputName;
    [alert addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self addBus:inputName.text];
    }]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = [[UIDevice currentDevice] name];
        inputName = textField;
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) addBus:(NSString*) busName {
    NSString* encodedBusName = [busName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *urlString = [@"http://snapup.apphb.com/Buses/Create?mobileId=1&name=" stringByAppendingString:encodedBusName];
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
                    
                    if ([json objectForKey:@"statusCode"] && [[json objectForKey:@"statusCode"] isEqualToString:@"200"]) {
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
            NSLog(@"OMG, iz deletit");
        }
    }
}

@end
