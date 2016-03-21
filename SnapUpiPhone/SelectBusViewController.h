//
//  SelectBusViewController.h
//  SnapUpiPhone
//
//  Created by WEI JOON JOSEPH HO on 2016-03-11.
//  Copyright © 2016 Cryptic Android. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Reachability.h>
#import "BusOrigin.h"
#import "BusOriginList.h"
#import "InterfaceUtilities.h"

@interface SelectBusViewController : UIViewController <UITableViewDelegate, NSURLSessionDataDelegate> {
    BusOriginList * busOriginList;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSData *assetDataToUpload;
@property NSString *fileName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *uploadButton;
@property BOOL didUpload;

@end
