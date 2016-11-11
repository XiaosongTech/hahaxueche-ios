//
//  HHVoucherView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 11/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHVoucherView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHFormatUtility.h"

@implementation HHVoucherView

- (instancetype)initWithVoucher:(HHVoucher *)voucher {
    self = [super init];
    if (self) {
        self.lefImgView = [[UIImageView alloc] init];
        if ([voucher.status integerValue] != 0) {
            self.lefImgView.image = [UIImage imageNamed:@"gray_voucher"];
        } else {
            self.lefImgView.image = [UIImage imageNamed:@"orange_vouvher"];
        }
        [self addSubview:self.lefImgView];
        [self.lefImgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.width.mas_equalTo(100.0f);
            make.height.equalTo(self.height);
            make.top.equalTo(self.top);
        }];
        
        self.amountLabel = [[UILabel alloc] init];
        [self addSubview:self.amountLabel];
        [self.amountLabel makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.lefImgView);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor darkTextColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.text = voucher.title;
        [self addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.centerY).offset(-5.0f);
            make.left.equalTo(self.lefImgView.right).offset(20.0f);
            make.right.equalTo(self.right).offset(-10.0f);
        }];
        
        self.expLabel = [[UILabel alloc] init];
        self.expLabel.textColor = [UIColor HHLightTextGray];
        self.expLabel.font = [UIFont systemFontOfSize:12.0f];
        self.expLabel.text = [NSString stringWithFormat:@"有效期至 %@", [[HHFormatUtility fullDateFormatter] stringFromDate:voucher.expiredAt]];
        [self addSubview:self.expLabel];
        [self.expLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.centerY);
            make.left.equalTo(self.titleLabel.left);
        }];
        
        self.statusImgView = [[UIImageView alloc] init];
        if ([voucher.status integerValue] == 0) {
            self.statusImgView.image = [UIImage imageNamed:@"ic_unused"];
        } else if ([voucher.status integerValue] == 1) {
            self.statusImgView.image = [UIImage imageNamed:@"ic_used"];
        } else {
            self.statusImgView.image = [UIImage imageNamed:@"ic_overdue"];
        }
        [self addSubview:self.statusImgView];
        [self.statusImgView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY).offset(-5.0f);
            make.right.equalTo(self.right).offset(-10.0f);
        }];
    }
    return self;
}

@end
