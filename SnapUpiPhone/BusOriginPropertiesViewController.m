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
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete Bus" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            [self deleteBusOrigin];
        }]];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    else {
        UIAlertController *noInternetAlert = [InterfaceUtilities createAlertDialogWithTitle:@"Deleting Bus Unavailable" Message:@"You need to be connected to your network or Wi-Fi to delete your bus."];
        [self presentViewController:noInternetAlert animated:YES completion:nil];
    }
}

- (void) deleteBusOrigin {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", @"http://snapup.apphb.com/Buses/Delete?mobileId=1&code=", self.busOrigin.code];
    
    __block NSDictionary *json;
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                if(data != nil) {
                    json = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
                    if ([[json objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                        self.didDelete = true;
                        [self performSegueWithIdentifier:@"BusOriginPropertiesToBuses" sender:self];
                    }
                }
            }] resume];
    // If we get here, the bus exists on the phone, but not the server...
    self.didDelete = true;
    [self performSegueWithIdentifier:@"BusOriginPropertiesToBuses" sender:self];
}

@end
