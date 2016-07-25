//
//  HHActivityView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/25/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHActivity.h"

@interface HHActivityView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UILabel *countDownLabel;
@property (nonatomic, strong) UIView *botLine;

@property (nonatomic, strong) HHActivity *activity;
@property (nonatomic) BOOL fullLine;

- (instancetype)initWithActivity:(HHActivity *)activity fullLine:(BOOL)fullLine;

@end
