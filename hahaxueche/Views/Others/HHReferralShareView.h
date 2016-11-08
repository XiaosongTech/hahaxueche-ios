//
//  HHReferralShareView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/3/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHReferShareViewBlock)();

@interface HHReferralShareView : UIView

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *botView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *verticalLine;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) HHReferShareViewBlock cancelBlock;
@property (nonatomic, strong) HHReferShareViewBlock shareBlock;

@end
