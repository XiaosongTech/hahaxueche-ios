//
//  HHGuardItemTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 23/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHGuardItemTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHGuardItemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconView];
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.left).offset(30.0f);
        make.top.equalTo(self.contentView.top).offset(15.0f);
    }];
    
    self.titleLabel = [self buildLabelWithFont:[UIFont systemFontOfSize:18.0f] color:[UIColor HHTextDarkGray]];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(50.0f);
        make.centerY.equalTo(self.iconView.centerY);
    }];
    
    self.subTitleLabel = [self buildLabelWithFont:[UIFont systemFontOfSize:11.0f] color:[UIColor HHLightestTextGray]];
    [self.contentView addSubview:self.subTitleLabel];
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.titleLabel.bottom).offset(3.0f);
        make.right.equalTo(self.contentView.right).offset(-15.0f);
    }];
    
    self.verifiedLabel = [self buildLabelWithFont:[UIFont systemFontOfSize:14.0f] color:[UIColor HHLinkBlue]];
    [self.contentView addSubview:self.verifiedLabel];
    [self.verifiedLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-20.0f);
        make.centerY.equalTo(self.titleLabel.centerY);
    }];
    
    self.botLine = [[UIView alloc] init];
    self.botLine.backgroundColor = [UIColor HHLightLineGray];
    [self.contentView addSubview:self.botLine];
    [self.botLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15.0f);
        make.right.equalTo(self.contentView.right).offset(-15.0f);
        make.bottom.equalTo(self.contentView.bottom);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
}


- (UILabel *)buildLabelWithFont:(UIFont *)font color:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = textColor;
    label.font = font;
    label.numberOfLines = 0;
    return label;
}

- (void)setupWithIcon:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle verifiedText:(NSString *)verifiedText {
    self.iconView.image = image;
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
    self.verifiedLabel.text = verifiedText;
}


@end
