//
//  HHReferrals.h
//  hahaxueche
//
//  Created by Zixiao Wang on 5/1/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "HHReferral.h"

@interface HHReferrals : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSArray *referrals;
@property (nonatomic, copy) NSString *nextPage;
@property (nonatomic, copy) NSString *prePage;

@end
