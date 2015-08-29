//
//  HHPaymentStatus.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/28/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface HHPaymentStatus : AVObject<AVSubclassing>

@property (nonatomic, copy) NSString *transactionId;
@property (nonatomic, copy) NSNumber *stageOneAmount;
@property (nonatomic, copy) NSNumber *stageTwoAmount;
@property (nonatomic, copy) NSNumber *stageThreeAmount;
@property (nonatomic, copy) NSNumber *stageFourAmount;
@property (nonatomic, copy) NSNumber *stageFiveAmount;
@property (nonatomic, copy) NSNumber *currentStage;

@end
