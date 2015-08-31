//
//  HHTransaction.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/27/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface HHTransaction : AVObject<AVSubclassing>

@property (nonatomic, copy) NSString *studentId;
@property (nonatomic, copy) NSString *coachId;
@property (nonatomic, strong) NSNumber *paidPrice;
@property (nonatomic, copy) NSString *paymentMethod;

@end
