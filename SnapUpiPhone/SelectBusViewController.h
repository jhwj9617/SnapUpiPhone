//
//  SelectBusViewController.h
//  SnapUpiPhone
//
//  Created by WEI JOON JOSEPH HO on 2016-03-11.
//  Copyright © 2016 Cryptic Android. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusOrigin.h"
#import "BusOriginList.h"

@interface SelectBusViewController : UIViewController <UITableViewDelegate> {
    BusOriginList * busOriginList;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property UIImage *assetToUpload;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *uploadButton;
@property BOOL didUpload;

@end
