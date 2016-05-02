//
//  HHReferral.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/27/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHReferral : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *referralId;
@property (nonatomic, copy) NSNumber *refereeBonusAmount;
@property (nonatomic, copy) NSNumber *refererBonusAmount;
@property (nonatomic, copy) NSString *refereeName;
@property (nonatomic, copy) NSString *refereeAvatar;
@property (nonatomic, copy) NSNumber *status;

- (NSString *)getStatusString;

@end
