//
//  BusOrigin.m
//  SnapUpiPhone
//
//  Created by WEI JOON JOSEPH HO on 2016-03-13.
//  Copyright © 2016 Cryptic Android. All rights reserved.
//

#import "BusOrigin.h"

@implementation BusOrigin

// Encode an object for an archive
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.code forKey:@"code"];
}
// Decode an object from an archive
- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.code = [coder decodeObjectForKey:@"code"];
    }
    return self;
}


@end
