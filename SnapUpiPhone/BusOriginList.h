//
//  BusOriginList.h
//  SnapUpiPhone
//
//  Created by WEI JOON JOSEPH HO on 2016-03-13.
//  Copyright © 2016 Cryptic Android. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusOrigin.h"

@interface BusOriginList : NSObject <NSCoding, UITableViewDataSource> {
    
}

@property NSMutableArray *busOrigins;

- (void) addBusOrigin:(BusOrigin *) busOrigin;
- (void) deleteBusOrigin:(BusOrigin *) busOrigin;

@end
