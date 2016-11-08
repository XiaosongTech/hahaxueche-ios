//
//  HHCityOtherFee.h
//  hahaxueche
//
//  Created by Zixiao Wang on 25/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHCityOtherFee : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *feeName;
@property (nonatomic, copy) NSString *feeDes;

@end
