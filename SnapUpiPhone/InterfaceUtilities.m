//
//  InterfaceUtilities.m
//  SnapUpiPhone
//
//  Created by WEI JOON JOSEPH HO on 2016-03-16.
//  Copyright © 2016 Cryptic Android. All rights reserved.
//

#import "InterfaceUtilities.h"

@implementation InterfaceUtilities

+ (UIAlertController *) createAlertDialogWithTitle:(NSString *) title Message:(NSString *) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    return alert;
}

@end
