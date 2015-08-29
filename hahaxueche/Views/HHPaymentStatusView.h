//
//  HHPaymentStatusView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/28/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PaymentStage) {
    StageDummy,
    StageOne,
    StageTwo,
    StageThree,
    StageFour,
    StageFive,
};

@interface HHPaymentStatusView : UIView

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic) PaymentStage stage;
@property (nonatomic) PaymentStage currentStage;

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UIImageView *infoImageView;


- (instancetype)initWithAmount:(NSNumber *)amount currentStage:(PaymentStage)currentStage stage:(PaymentStage)stage;

@end
