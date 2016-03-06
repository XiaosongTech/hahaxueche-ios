//
//  HHPaymentStatus.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHPaymentStage : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *paymentStageId;
@property (nonatomic, copy) NSDate *paidAt;
@property (nonatomic, copy) NSString *paymentMethodId;
@property (nonatomic, copy) NSNumber *reviewable;
@property (nonatomic, copy) NSNumber *reviewed;
@property (nonatomic, copy) NSNumber *readyForReview;
@property (nonatomic, copy) NSNumber *stageAmount;
@property (nonatomic, copy) NSString *stageName;
@property (nonatomic, copy) NSNumber *stageNumber;
@property (nonatomic, copy) NSString *explanationText;
@property (nonatomic, copy) NSString *coachUserId;


@end
