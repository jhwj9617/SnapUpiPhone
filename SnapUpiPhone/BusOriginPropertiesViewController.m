//
//  BusOriginPropertiesViewController.m
//  SnapUpiPhone
//
//  Created by WEI JOON JOSEPH HO on 2016-03-14.
//  Copyright © 2016 Cryptic Android. All rights reserved.
//

#import "BusOriginPropertiesViewController.h"

@implementation BusOriginPropertiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.busNameText.text = self.busOrigin.name;
    self.busCodeText.text = self.busOrigin.code;
    self.didDelete = false;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (IBAction)deleteBusButtonPressed:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete Bus" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        NSLog(@"DeletedBus");
        [self deleteBusOrigin];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void) deleteBusOrigin {
//    NSString *urlString = [@"http://snapup.apphb.com/Buses/Create?mobileId=1&name=" stringByAppendingString:encodedBusName];
//    NSLog(@"%@", urlString);
//    
//    __block NSDictionary *json;
//    NSURLSession *session = [NSURLSession sharedSession];
//    [[session dataTaskWithURL:[NSURL URLWithString:urlString]
//            completionHandler:^(NSData *data,
//                                NSURLResponse *response,
//                                NSError *error) {
//                NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"%@", strData);
//                if(data != nil) {
//                    json = [NSJSONSerialization JSONObjectWithData:data
//                                                           options:NSJSONReadingAllowFragments
//                                                             error:&error];
//                    
//                    if ([json objectForKey:@"statusCode"] && [[json objectForKey:@"statusCode"] isEqualToString:@"200"]) {
//                        BusOrigin *newBusOrigin = [[BusOrigin alloc] init];
//                        newBusOrigin.name = busName;
//                        newBusOrigin.code = [json objectForKey:@"code"];
//                        [busOriginList addBusOrigin:newBusOrigin];
//                        [self saveBusOriginList];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [self.tableView reloadData];
//                        });
//                    }
//                }
//            }] resume];
    self.didDelete = true;
    [self performSegueWithIdentifier:@"BusOriginPropertiesToBuses" sender:self];
}

@end
