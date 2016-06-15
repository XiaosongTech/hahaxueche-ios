//
//  HHBonus.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/30/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHBonus : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *bonusName;
@property (nonatomic, copy) NSNumber *bonusAmount;

@end
