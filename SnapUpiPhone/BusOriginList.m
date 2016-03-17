//
//  BusOriginList.m
//  SnapUpiPhone
//
//  Created by WEI JOON JOSEPH HO on 2016-03-13.
//  Copyright © 2016 Cryptic Android. All rights reserved.
//

#import "BusOriginList.h"

@implementation BusOriginList

- (id) init {
    self.busOrigins = [[NSMutableArray alloc] init];
    return self;
}

- (void) addBusOrigin:(BusOrigin *) busOrigin {
    [self.busOrigins insertObject:busOrigin atIndex:0];
}

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.busOrigins forKey:@"busOrigins"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.busOrigins = [decoder decodeObjectForKey:@"busOrigins"];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger tableViewTag = [tableView tag]; // Buses View = 0; Select Bus = 1;
    BusOrigin *busOrigin = [self.busOrigins objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = busOrigin.name;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:label];
    [cell.contentView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:label
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:cell.contentView
                                     attribute:NSLayoutAttributeLeading
                                     multiplier:1.0f constant:30.0f]];
    [cell.contentView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:label
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:cell.contentView
                                     attribute:NSLayoutAttributeCenterY
                                     multiplier:1.0f constant:0.0f]];
    
    if (tableViewTag == 0) {
        UIButton *button = [[UIButton alloc] init];
        [button setEnabled:false];
        UIImage *buttonImage = [UIImage imageNamed:@"angle_right.png"];
        // Current workaround. Button image disappears without a title.
        [button setTitle:@"Button" forState:UIControlStateNormal];
        button.titleLabel.layer.opacity = 0.0f;
        [button setImage:buttonImage forState:UIControlStateNormal];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:button];
        [cell.contentView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:button
                                         attribute:NSLayoutAttributeTrailing
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:cell.contentView
                                         attribute:NSLayoutAttributeTrailing
                                         multiplier:1.0f constant:30.0f]];
        [cell.contentView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:button
                                         attribute:NSLayoutAttributeCenterY
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:cell.contentView
                                         attribute:NSLayoutAttributeCenterY
                                         multiplier:1.0f constant:0.0f]];
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.busOrigins count];
}


@end
