//
//  HHPersonalCoachPrice.h
//  hahaxueche
//
//  Created by Zixiao Wang on 25/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHPersonalCoachPrice : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *licenseType;
@property (nonatomic) NSNumber *duration;
@property (nonatomic) NSNumber *price;
@property (nonatomic) NSString *des;

@end
