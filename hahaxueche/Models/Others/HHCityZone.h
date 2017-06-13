//
//  HHCityZone.h
//  hahaxueche
//
//  Created by Zixiao Wang on 08/06/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHCityZone : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *zoneName;
@property (nonatomic, copy) NSArray *areas;

@end
