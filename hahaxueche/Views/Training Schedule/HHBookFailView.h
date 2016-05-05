//
//  HHBookFailView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/9/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHConfirmCancelButtonsView.h"

typedef void (^HHBookFailCancelBlock)();

typedef NS_ENUM(NSInteger, ErrorType) {
    ErrorTypeNeedCoachReview, // 有未评级课程
    ErrorTypeHasIncomplete, // 有未完成课程
};

@interface HHBookFailView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIView *botLine;
@property (nonatomic, strong) UILabel *expLabel;
@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) HHBookFailCancelBlock cancelBlock;


- (instancetype)initWithFrame:(CGRect)frame type:(ErrorType)type;

@end
