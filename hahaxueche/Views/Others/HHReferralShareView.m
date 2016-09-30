//
//  HHReferralShareView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/3/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHReferralShareView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHConstantsStore.h"
#import "NSNumber+HHNumber.h"

@implementation HHReferralShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0f;
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor HHOrange];
    [self addSubview:self.topView];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = 3.0f;
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"用@哈哈学车爽到飞起  \n好东西不私藏~马上分享给大家" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:paragraphStyle}];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.attributedText = titleString;
    [self.topView addSubview:self.titleLabel];
    
    NSMutableAttributedString *subTitleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"好东西要分享给朋友，好友通过分享链接并报名哈哈学车后，你将获得%@元现金奖励，更有机会获得保时捷试驾一日游，上不封顶哦~", [[[HHConstantsStore sharedInstance] getCityReferrerBonus] generateMoneyString]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:paragraphStyle}];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.numberOfLines = 0;
    self.subTitleLabel.attributedText = subTitleString;
    [self.topView addSubview:self.subTitleLabel];
    
    self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_pop_xiaoha"]];
    [self.topView addSubview:self.imgView];
    
    self.botView = [[UIView alloc] init];
    self.botView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.botView];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitle:@"残忍拒绝" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor HHLightTextGray] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.botView addSubview:self.cancelButton];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setTitle:@"分享一下, 赚回学费" forState:UIControlStateNormal];
    [self.shareButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(shareButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.botView addSubview:self.shareButton];
    
    self.verticalLine = [[UIView alloc] init];
    self.verticalLine.backgroundColor = [UIColor HHLightLineGray];
    [self.botView addSubview:self.verticalLine];
    
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(240.0f);
    }];
    
    [self.botView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(60.0f);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.top).offset(20.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topView.bottom);
        make.left.equalTo(self.left).offset(20.0f);
    }];
    
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.top).offset(-15.0f);
        make.left.equalTo(self.left).offset(140.0f);
        make.right.equalTo(self.right).offset(-20.0f);
        make.bottom.lessThanOrEqualTo(self.bottom);
    }];
    
    [self.cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botView.centerY);
        make.left.equalTo(self.botView.left);
        make.height.equalTo(self.botView.height);
        make.width.equalTo(self.botView.width).multipliedBy(1/3.0f);
    }];
    
    [self.verticalLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botView.centerY);
        make.left.equalTo(self.cancelButton.right);
        make.height.equalTo(self.botView.height).offset(-20.0f);
        make.width.mas_equalTo(1.0f/[UIScreen mainScreen].scale);

    }];
    
    [self.shareButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botView.centerY);
        make.left.equalTo(self.verticalLine.right);
        make.height.equalTo(self.botView.height);
        make.right.equalTo(self.botView.right);
    }];
}

- (void)cancelButtonTapped {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)shareButtonTapped {
    if (self.shareBlock) {
        self.shareBlock();
    }
}

@end
