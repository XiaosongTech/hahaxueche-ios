//
//  HHActivity.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/25/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHEvent : MTLModel <MTLJSONSerializing>

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSDate *endDate;
@property(nonatomic, strong) NSNumber *type;
@property(nonatomic, strong) NSString *webURL;
@property(nonatomic, strong) NSString *icon;

@end
