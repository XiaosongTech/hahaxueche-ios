//
//  HHCoachListViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachListViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

static CGFloat const kAvatarRadius = 30.0f;

@implementation HHCoachListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return  self;
}

- (void)initSubviews {
    self.avatarView = [[UIImageView alloc] init];
    self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarView.layer.cornerRadius = kAvatarRadius;
    self.avatarView.layer.masksToBounds = YES;
    self.avatarView.image = [UIImage imageNamed:@"pic_local"];
    [self.contentView addSubview:self.avatarView];
    
    self.nameLabel = [self createLabelWithFont:[UIFont systemFontOfSize:20.0f] textColor:[UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1]];
    self.nameLabel.text = @"老张";
    [self.nameLabel sizeToFit];
    [self.contentView addSubview:self.nameLabel];
    
    self.goldenCoachIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_auth_golden"]];
    self.goldenCoachIcon.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:self.goldenCoachIcon];
    
    self.trainingYearLabel = [self createLabelWithFont:[UIFont systemFontOfSize:16.0f] textColor:[UIColor HHLightTextGray]];
    self.trainingYearLabel.text = @"11年教龄";
    [self.trainingYearLabel sizeToFit];
    [self.contentView addSubview:self.trainingYearLabel];
    
    self.priceLabel = [self createLabelWithFont:[UIFont systemFontOfSize:20.0f] textColor:[UIColor HHOrange]];
    self.priceLabel.text = @"2000";
    [self.priceLabel sizeToFit];
    [self.contentView addSubview:self.priceLabel];
    
    self.marketPriceLabel = [[UILabel alloc] init];;
    self.marketPriceLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:@"2500" attributes:@{NSStrikethroughStyleAttributeName:@(1), NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
    
    [self.marketPriceLabel sizeToFit];
    [self.contentView addSubview:self.marketPriceLabel];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor HHLightLineGray];
    [self.contentView addSubview:self.bottomLine];
    
    [self makeConstraints];
    
}

- (void)makeConstraints {
    [self.avatarView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.left.equalTo(self.contentView.left).offset(20.0f);
        make.width.mas_equalTo(kAvatarRadius * 2.0f);
        make.height.mas_equalTo(kAvatarRadius * 2.0f);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.right).offset(20.0f);
        make.top.equalTo(self.contentView.top).offset(16.0f);
    }];
    
    [self.goldenCoachIcon makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.right).offset(5.0f);
        make.centerY.equalTo(self.nameLabel.centerY);
    }];
    
    [self.trainingYearLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goldenCoachIcon.right).offset(5.0f);
        make.bottom.equalTo(self.nameLabel.bottom);
    }];
    
    [self.priceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY).offset(-12.0f);
        make.right.equalTo(self.contentView.right).offset(-20.0f);
    }];
    
    [self.marketPriceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY).offset(12.0f);
        make.right.equalTo(self.contentView.right).offset(-20.0f);
    }];
    
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.bottom);
        make.left.equalTo(self.avatarView.right).offset(20.0f);
        make.right.equalTo(self.contentView.right).offset(-20.0f);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
}


- (UILabel *)createLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end
