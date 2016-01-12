//
//  HHCity.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHCity : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *cityId;
@property (nonatomic, copy) NSString *cityName;

@end
