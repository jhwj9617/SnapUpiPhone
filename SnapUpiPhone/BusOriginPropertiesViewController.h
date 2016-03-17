//
//  BusOriginPropertiesViewController.h
//  SnapUpiPhone
//
//  Created by WEI JOON JOSEPH HO on 2016-03-14.
//  Copyright © 2016 Cryptic Android. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusOrigin.h"

@interface BusOriginPropertiesViewController : UIViewController

@property BusOrigin *busOrigin;
@property (strong, nonatomic) IBOutlet UILabel *busNameText;
@property (strong, nonatomic) IBOutlet UILabel *busCodeText;
@property BOOL didDelete;

@end
