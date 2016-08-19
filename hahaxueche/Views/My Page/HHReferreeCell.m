//
//  HHReferreeCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/19/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHReferreeCell.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHConstantsStore.h"
#import "NSNumber+HHNumber.h"

@implementation HHReferreeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
       
        self.nameLabel = [self buildLabelWithColor:[UIColor HHLightTextGray] font:[UIFont systemFontOfSize:20.0f]];
        [self.contentView addSubview:self.nameLabel];
        
        
        self.numberLabel = [self buildLabelWithColor:[UIColor HHLightTextGray] font:[UIFont systemFontOfSize:16.0f]];
        [self.contentView addSubview:self.numberLabel];
        
        self.statusLabel = [self buildLabelWithColor:[UIColor HHLightestTextGray] font:[UIFont systemFontOfSize:14.0f]];
        [self.contentView addSubview:self.statusLabel];
        
        self.moneyLabel = [self buildLabelWithColor:[UIColor HHOrange] font:[UIFont systemFontOfSize:22.0f]];
        self.moneyLabel.text = [[[HHConstantsStore sharedInstance] getCityReferrerBonus] generateMoneyString];
        [self.contentView addSubview:self.moneyLabel];
        
        self.botLine = [[UIView alloc] init];
        self.botLine.backgroundColor = [UIColor HHLightLineGray];
        [self.contentView addSubview:self.botLine];
        
        [self.botLine makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.bottom);
            make.left.equalTo(self.nameLabel.left);
            make.right.equalTo(self.moneyLabel.right);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
        
        [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(20.0f);
            make.bottom.equalTo(self.contentView.centerY).offset(-2.0f);
        }];
        
        [self.numberLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.right).offset(5.0f);
            make.bottom.equalTo(self.nameLabel.bottom);
        }];
        
        [self.statusLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.left);
            make.top.equalTo(self.contentView.centerY).offset(2.0f);
        }];
        
        [self.moneyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.right).offset(-20.0f);
            make.centerY.equalTo(self.contentView.centerY);
        }];
        
    }
    return self;
}


- (UILabel *)buildLabelWithColor:(UIColor *)textColor font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    return label;
}

- (void)setupCellWithReferral:(HHReferral *)referral {
    self.nameLabel.text = referral.name;
    self.numberLabel.text = referral.phone;
    if (referral.purchasedAt) {
        self.statusLabel.text = @"已购买教练";
    } else {
        self.statusLabel.text = @"未购买教练";
    }
}

@end
