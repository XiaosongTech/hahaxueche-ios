//
//  HHMyPageUserInfoCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyPageUserInfoCell.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import <UIImageView+WebCache.h>
#import "NSNumber+HHNumber.h"

static CGFloat const avatarRadius = 40.0f;

@implementation HHMyPageUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_mypage_bk"]];
    [self.contentView addSubview:self.topImageView];
    
    self.avatarBackgroungView = [[UIView alloc] init];
    self.avatarBackgroungView.backgroundColor = [UIColor whiteColor];
    self.avatarBackgroungView.layer.cornerRadius = avatarRadius;
    self.avatarBackgroungView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.avatarBackgroungView];
    
    self.avatarView = [[UIImageView alloc] init];
    self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarView.layer.cornerRadius = avatarRadius-2.0f;
    self.avatarView.layer.masksToBounds = YES;
    self.avatarView.userInteractionEnabled = YES;
    [self.avatarBackgroungView addSubview:self.avatarView];
    
    UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarViewTapped)];
    [self.avatarView addGestureRecognizer:tapRecognizer2];
    [self.contentView bringSubviewToFront:self.avatarBackgroungView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor HHTextDarkGray];
    self.nameLabel.font = [UIFont systemFontOfSize:20.0f];
    [self.contentView addSubview:self.nameLabel];
    
    
    self.balanceView = [[HHMyPageUserInfoView alloc] init];
    [self addSubview:self.balanceView];
    
    self.paymentView = [[HHMyPageUserInfoView alloc] init];
    [self addSubview:self.paymentView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(paymentViewTapped)];
    [self.paymentView addGestureRecognizer:tapRecognizer];
    
    
    
    self.verticalLine = [[UIView alloc] init];
    self.verticalLine.backgroundColor = [UIColor HHLightLineGray];
    [self addSubview:self.verticalLine];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.topImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.height.mas_equalTo(150.0f);
    }];
    
    [self.avatarBackgroungView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topImageView.bottom).offset(-10.0f);
        make.centerX.equalTo(self.contentView.centerX);
        make.width.mas_equalTo(avatarRadius * 2.0f);
        make.height.mas_equalTo(avatarRadius * 2.0);
    }];
    
    [self.avatarView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.avatarBackgroungView);
        make.width.mas_equalTo((avatarRadius - 2.0f) * 2.0f);
        make.height.mas_equalTo((avatarRadius - 2.0f) * 2.0f);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.centerX);
        make.top.equalTo(self.avatarBackgroungView.bottom).offset(5.0f);
    }];
    
    [self.balanceView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.bottom.equalTo(self.contentView.bottom);
        make.width.equalTo(self.contentView.width).multipliedBy(0.5f);
        make.top.equalTo(self.nameLabel.bottom).offset(10.0f);
    }];
    
    [self.paymentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.balanceView.right);
        make.bottom.equalTo(self.contentView.bottom);
        make.width.equalTo(self.contentView.width).multipliedBy(0.5f);
        make.top.equalTo(self.nameLabel.bottom).offset(10.0f);
    }];
    
    [self.verticalLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.bottom).offset(10.0f);
        make.centerX.equalTo(self.centerX);
        make.width.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        make.bottom.equalTo(self.contentView.bottom);
    }];
}

- (void)setupCellWithStudent:(HHStudent *)student {
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:student.avatarURL]];
    self.nameLabel.text = student.name;
    
    HHPurchasedService *purchasedService;
    if ([student.purchasedServiceArray count]) {
        purchasedService = [student.purchasedServiceArray firstObject];
    }
    
    NSString *balanceString = [@(0) generateMoneyString];
    NSString *stageString = @"未购买教练";
    BOOL showStageArrow = NO;
    if (purchasedService) {
        balanceString = [purchasedService.unpaidAmount generateMoneyString];
        showStageArrow = YES;
        HHPaymentStage *stage = [purchasedService getCurrentPaymentStage];
        stageString = stage.stageName;
    }
    
    [self.balanceView setupViewWithTitle:@"账户余额" value:balanceString showArrow:NO];

    [self.paymentView setupViewWithTitle:@"打款状态" value:stageString showArrow:showStageArrow];
}

- (void)paymentViewTapped {
    if (self.paymentViewActionBlock) {
        self.paymentViewActionBlock();
    }
}

- (void)avatarViewTapped {
    if (self.avatarViewActionBlock) {
        self.avatarViewActionBlock();
    }
}

@end
