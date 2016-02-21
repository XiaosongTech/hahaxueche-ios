//
//  HHPaymentStatusTopView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/20/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPaymentStatusTopView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

static CGFloat const kAvatarRadius = 30.0f;

@implementation HHPaymentStatusTopView

- (instancetype)initWithPurchasedService:(HHPurchasedService *)purchasedService {
    self = [super init];
    if (self) {
        self.purchasedService = purchasedService;
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews {
    self.backgroundColor = [UIColor HHOrange];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.attributedText = [self buildCoachString];
    [self addSubview:self.nameLabel];
    
    self.dateLabel = [self buildLabelWithText:@"2016-02-01"];
    [self addSubview:self.dateLabel];
    
    self.transactionIdLabel = [self buildLabelWithText:@"收据编号：222938812738283720shd"];
    [self addSubview:self.transactionIdLabel];
    
    self.avatarView = [[UIImageView alloc] init];
    self.avatarView.image = [UIImage imageNamed:@"pic_local"];
    self.avatarView.layer.masksToBounds = YES;
    self.avatarView.layer.cornerRadius = kAvatarRadius;
    [self addSubview:self.avatarView];
    
    self.midLine = [[UIView alloc] init];
    self.midLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.midLine];
    
    self.totalAmountView = [[HHMoneyAmountView alloc] initWithTitle:@"总金额" value:@"￥2800"];
    [self addSubview:self.totalAmountView];
    
    self.payedAmountView = [[HHMoneyAmountView alloc] initWithTitle:@"已打款" value:@"￥2000"];
    [self addSubview:self.payedAmountView];
    
    self.leftAmountView = [[HHMoneyAmountView alloc] initWithTitle:@"待打款" value:@"￥800"];
    [self addSubview:self.leftAmountView];
    
    [self makeConstraints];
    
}

- (UILabel *)buildLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12.0f];
    return label;
}

- (NSMutableAttributedString *)buildCoachString {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"老张" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:20.0f]}];

     NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@" 教练" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    [string appendAttributedString:string2];
    return string;
}

- (void)makeConstraints {
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(35.0f);
        make.left.equalTo(self.left).offset(20.0f);
    }];
    
    [self.dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.bottom).offset(5.0f);
        make.left.equalTo(self.left).offset(20.0f);
    }];
    
    [self.transactionIdLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.bottom).offset(5.0f);
        make.left.equalTo(self.dateLabel.left);
    }];
    
    [self.avatarView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.top);
        make.right.equalTo(self.right).offset(-20.0f);
        make.width.mas_equalTo(kAvatarRadius * 2.0f);
        make.height.mas_equalTo(kAvatarRadius * 2.0f);
    }];
    
    [self.midLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(self.width).offset(-40.0f);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        make.top.equalTo(self.transactionIdLabel.bottom).offset(10.0f);
    }];
    
    [self.totalAmountView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(20);
        make.top.equalTo(self.midLine.bottom);
        make.bottom.equalTo(self.bottom);
        make.width.equalTo(self.width).multipliedBy(1/3.0f).offset(-40.0f/3.0f);
    }];
    
    [self.payedAmountView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalAmountView.right);
        make.top.equalTo(self.totalAmountView.top);
        make.bottom.equalTo(self.totalAmountView.bottom);
        make.width.equalTo(self.width).multipliedBy(1/3.0f).offset(-40.0f/3.0f);
    }];
    
    [self.leftAmountView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payedAmountView.right);
        make.top.equalTo(self.totalAmountView.top);
        make.bottom.equalTo(self.totalAmountView.bottom);
        make.width.equalTo(self.width).multipliedBy(1/3.0f).offset(-40.0f/3.0f);
    }];
}

@end
