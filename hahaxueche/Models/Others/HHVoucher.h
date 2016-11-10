//
//  HHVoucher.h
//  hahaxueche
//
//  Created by Zixiao Wang on 10/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHVoucher : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *voucherId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSDate *expiredAt;
@property (nonatomic, copy) NSNumber *amount;
@property (nonatomic, copy) NSNumber *status;


- (NSString *)getStatusString;

@end
