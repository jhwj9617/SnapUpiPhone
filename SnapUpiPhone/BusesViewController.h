//
//  ViewController.h
//  SnapUpiPhone
//
//  Created by WEI JOON JOSEPH HO on 2016-03-09.
//  Copyright © 2016 Cryptic Android. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusOrigin.h"
#import "BusOriginList.h"
#import "BusOriginPropertiesViewController.h"

@interface BusesViewController : UIViewController <UITableViewDelegate> {
    BusOriginList * busOriginList;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

