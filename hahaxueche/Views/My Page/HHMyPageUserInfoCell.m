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

static CGFloat const avatarRadius = 35.0f;

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
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.contentView addSubview:self.nameLabel];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editButton setImage:[UIImage imageNamed:@"ic_edit"] forState:UIControlStateNormal];
    [self.editButton addTarget:self action:@selector(editName) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.editButton];
    
    self.courseLabel = [[UILabel alloc] init];
    self.courseLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    self.courseLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.courseLabel];
    
    
    self.balanceView = [[HHMyPageUserInfoView alloc] init];
    [self.contentView addSubview:self.balanceView];
    
    self.paymentView = [[HHMyPageUserInfoView alloc] init];
    [self.contentView addSubview:self.paymentView];
    
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
        make.height.mas_equalTo(200.0f);
    }];
    
    [self.avatarBackgroungView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(20.0f);
        make.centerX.equalTo(self.topImageView.centerX);
        make.width.mas_equalTo(avatarRadius * 2.0f);
        make.height.mas_equalTo(avatarRadius * 2.0);
    }];
    
    [self.avatarView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.avatarBackgroungView);
        make.width.mas_equalTo((avatarRadius - 2.0f) * 2.0f);
        make.height.mas_equalTo((avatarRadius - 2.0f) * 2.0f);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topImageView.centerX);
        make.top.equalTo(self.avatarBackgroungView.bottom).offset(10.0f);
    }];
    
    [self.editButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.centerY);
        make.left.equalTo(self.nameLabel.right).offset(15.0f);
    }];
    
    [self.courseLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.nameLabel.centerX);
        make.top.equalTo(self.nameLabel.bottom).offset(5.0f);
    }];
    
    [self.balanceView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width).multipliedBy(0.5f);
        make.top.equalTo(self.topImageView.bottom).offset(10.0f);
        make.height.mas_equalTo(60.0f);
    }];
    
    [self.paymentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.balanceView.right);
        make.width.equalTo(self.contentView.width).multipliedBy(0.5f);
        make.top.equalTo(self.topImageView.bottom).offset(10.0f);
        make.height.mas_equalTo(60.0f);
    }];
    
    [self.verticalLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.bottom).offset(10.0f);
        make.centerX.equalTo(self.contentView.centerX);
        make.width.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        make.bottom.equalTo(self.contentView.bottom).offset(-10.0f);
    }];
}

- (void)setupCellWithStudent:(HHStudent *)student {
    [[SDImageCache sharedImageCache] removeImageForKey:student.avatarURL];
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:student.avatarURL] placeholderImage:[UIImage imageNamed:@"ic_mypage_ava"] options:SDWebImageHighPriority];
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
        
        if ([purchasedService isFinished]) {
            stageString = @"已拿证";
        }
    }
    
    [self.balanceView setupViewWithTitle:@"账户余额" value:balanceString showArrow:NO];

    [self.paymentView setupViewWithTitle:@"打款状态" value:stageString showArrow:showStageArrow];
    
    if (purchasedService) {
        self.courseLabel.text = [NSString stringWithFormat:@"目前阶段: %@", [student getCourseName]];
    } else {
        self.courseLabel.text = @"目前阶段: 未购买教练";
    }
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

- (void)editName {
    if (self.editNameBlock) {
        self.editNameBlock();
    }
}

@end
