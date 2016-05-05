//
//  HHWithdraw.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/27/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHWithdraw : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *withdrawId;
@property (nonatomic, copy) NSNumber *amount;
@property (nonatomic, copy) NSDate *redeemedDate;

@end
