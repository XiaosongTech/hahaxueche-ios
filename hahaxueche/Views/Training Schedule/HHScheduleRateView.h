//
//  HHScheduleRateView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHStarRatingView.h"
#import "HHConfirmCancelButtonsView.h"

typedef void (^HHRateScheduleConfirmBlock)(NSNumber *rating);
typedef void (^HHRateScheduleCancelBlock)();

@interface HHScheduleRateView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HHStarRatingView *ratingView;
@property (nonatomic, strong) HHConfirmCancelButtonsView *buttonsView;
@property (nonatomic, strong) HHRateScheduleConfirmBlock confirmBlock;
@property (nonatomic, strong) HHRateScheduleCancelBlock cancelBlock;

- (instancetype)initWithFrame:(CGRect)frame;

@end
