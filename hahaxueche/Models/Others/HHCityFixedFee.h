//
//  HHCityFixedFee.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/17/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHCityFixedFee : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *feeName;
@property (nonatomic, copy) NSNumber *feeAmount;

@end
