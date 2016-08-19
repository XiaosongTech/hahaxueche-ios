//
//  HHWithdraw.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/27/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHWithdraw : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSNumber *status;
@property (nonatomic, copy) NSNumber *amount;
@property (nonatomic, copy) NSDate *withdrawedAt;

- (NSString *)getStatusString;

@end
