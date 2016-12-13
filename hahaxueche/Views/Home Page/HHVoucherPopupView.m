//
//  HHVoucherPopupView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 13/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHVoucherPopupView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHFormatUtility.h"
#import "NSNumber+HHNumber.h"

@implementation HHVoucherPopupView


- (instancetype)initWithVoucher:(HHVoucher *)voucher {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 300.0f, 370.0f);
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_window"]];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.frame = CGRectZero;
        [self addSubview:imgView];
        
        UIImageView *couponView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_quanbg_big"]];
        couponView.frame = CGRectZero;
        [self addSubview:couponView];
        
        
        UILabel *titleLabel = [self buildLabelWithText:voucher.title font:[UIFont systemFontOfSize:16.0f] textColor:[UIColor HHBrown]];
        [self addSubview:titleLabel];
        
        UILabel *expireLabel = [self buildLabelWithText:[NSString stringWithFormat:@"有效期至: %@", [[HHFormatUtility fullDateFormatter] stringFromDate:voucher.expiredAt] ] font:[UIFont systemFontOfSize:11.0f] textColor:[UIColor HHBrown]];
        [self addSubview:expireLabel];
        
        
        UILabel *amountLabel = [self buildLabelWithText:[voucher.amount generateMoneyString] font:[UIFont boldSystemFontOfSize:20.0f] textColor:[UIColor HHOrange]];
        [self addSubview:amountLabel];
        
        UILabel *explanationLabel = [self buildLabelWithText:@"已放入你的账户, 请在<我的页面>查看" font:[UIFont systemFontOfSize:12.0f] textColor:[UIColor HHLightTextGray]];
        [self addSubview:explanationLabel];
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setTitle:@"分享给朋友" forState:UIControlStateNormal];
        [shareButton setBackgroundColor:[UIColor HHPink]];
        shareButton.layer.masksToBounds = YES;
        shareButton.layer.cornerRadius = 5.0f;
        shareButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [shareButton addTarget:self action:@selector(shareButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareButton];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setImage:[UIImage imageNamed:@"button_close"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.top.equalTo(self.top);
        }];
        [couponView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.top.equalTo(self.top).offset(185.0f);
        }];
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.top.equalTo(couponView.bottom).offset(5.0f);
        }];
        [expireLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.top.equalTo(titleLabel.bottom).offset(5.0f);
        }];
        
        [explanationLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.top.equalTo(expireLabel.bottom).offset(8.0f);
        }];
        [amountLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX).offset(-5.0f);
            make.centerY.equalTo(couponView.centerY);
        }];
        
        [shareButton makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom);
            make.centerX.equalTo(self.centerX);
            make.width.mas_equalTo(180.0f);
            make.height.mas_equalTo(40.0f);
        }];
        
        [cancelButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-10.0f);
            make.top.equalTo(self.top).offset(10.0f);
        }];
        
    }
    return self;
}

- (UILabel *)buildLabelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = text;
    label.font = font;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)shareButtonTapped {
    if (self.shareBlock) {
        self.shareBlock();
    }
}

- (void)cancelButtonTapped {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

@end
