//
//  HHConfirmScheduleBookView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/9/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoachSchedule.h"
#import "HHConfirmCancelButtonsView.h"

typedef void (^HHBookScheduleConfirmBlock)(HHCoachSchedule *schedule);
typedef void (^HHBookScheduleCancelBlock)();

@interface HHConfirmScheduleBookView : UIView

@property (nonatomic, strong) HHCoachSchedule *schedule;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIView *midLine;
@property (nonatomic, strong) UIView *botLine;
@property (nonatomic, strong) UILabel *expLabel;
@property (nonatomic, strong) HHConfirmCancelButtonsView *buttonsView;
@property (nonatomic, strong) HHBookScheduleConfirmBlock confirmBlock;
@property (nonatomic, strong) HHBookScheduleCancelBlock cancelBlock;


- (instancetype)initWithFrame:(CGRect)frame schedule:(HHCoachSchedule *)schedule isBooking:(BOOL)booking;

@end
