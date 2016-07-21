//
//  HHCoupon.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/19/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHCoupon : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSArray *content;
@property (nonatomic, strong) NSString *channelName;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString *promoCode;

@end
