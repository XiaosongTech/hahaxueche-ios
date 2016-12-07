//
//  HHSpecialVouchersView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 07/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHSpecialVouchersView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "NSNumber+HHNumber.h"

@implementation HHSpecialVouchersView

- (instancetype)initWithVouchers:(NSArray *)vouchers {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        for (HHVoucher *voucher in vouchers) {
            UIView *view = [self buildViewWithVoucher:voucher];
            [self addSubview:view];
            [view makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.top);
                make.left.equalTo(self.left).offset(20.0f);
                make.width.equalTo(self.width).offset(-40.0f);
                make.height.mas_equalTo(40.0f);
            }];
        }
        
        UIView *botLine = [[UIView alloc] init];
        botLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:botLine];
        [botLine makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
            make.bottom.equalTo(self.bottom);
        }];
    }
    return self;
}


- (UIView *)buildViewWithVoucher:(HHVoucher *)voucher {
    UIView *view = [[UIView alloc] init];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_cheap"]];
    [view addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.left.equalTo(view.left);
    }];

    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor HHConfirmRed];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.text = [NSString stringWithFormat:@"-%@", [voucher.amount generateMoneyString]];
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.right.equalTo(view.right);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = voucher.title;
    titleLabel.textColor =[UIColor HHLightTextGray];
    titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.left.equalTo(imgView.right).offset(5.0f);
        make.right.lessThanOrEqualTo(label.left).offset(-5.0f);
    }];
    
    
    return view;
}

@end
