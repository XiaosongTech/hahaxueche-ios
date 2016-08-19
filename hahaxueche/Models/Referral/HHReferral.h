//
//  HHReferral.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/27/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHReferral : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSDate *purchasedAt;


@end
