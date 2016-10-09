//
//  HHHomPageCardView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHHomPageCardView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@implementation HHHomPageCardView

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title subTitle:(NSMutableAttributedString *)subTitle bigIcon:(UIImage *)bigIcon items:(NSArray *)items dotColor:(UIColor *)dotColor {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0f;
        
        self.topContainerView = [[UIView alloc] init];
        [self addSubview:self.topContainerView];
        [self.topContainerView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(40.0f);
        }];
        
        self.botContainerView = [[UIView alloc] init];
        [self addSubview:self.botContainerView];
        [self.botContainerView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topContainerView.bottom);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.bottom.equalTo(self.bottom);
        }];
        
        self.iconView = [[UIImageView alloc] initWithImage:icon];
        [self.topContainerView addSubview:self.iconView];
        [self.iconView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topContainerView.centerY);
            make.left.equalTo(self.topContainerView.left).offset(15.0f);
            make.width.mas_equalTo(16.0f);
            make.height.mas_equalTo(16.0f);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor HHLightTextGray];
        self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        self.titleLabel.text = title;
        [self.topContainerView addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconView.centerY);
            make.left.equalTo(self.iconView.right).offset(5.0f);
        }];
        
        self.subTitleLabel = [[UILabel alloc] init];
        self.subTitleLabel.attributedText = subTitle;
        [self.topContainerView addSubview:self.subTitleLabel];
        [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topContainerView.centerY);
            make.right.equalTo(self.topContainerView.right).offset(-15.0f);
        }];
        
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = [UIColor HHLightLineGray];
        [self.topContainerView addSubview:self.line];
        [self.line makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topContainerView.left);
            make.bottom.equalTo(self.topContainerView.bottom);
            make.width.equalTo(self.topContainerView.width);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
        
        self.bigIconView = [[UIImageView alloc] initWithImage:bigIcon];
        [self.botContainerView addSubview:self.bigIconView];
        [self.bigIconView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.botContainerView.centerY);
            make.left.equalTo(self.botContainerView.left).offset(15.0f);

        }];
        
        self.firstItem = [[HHHomePageItemView alloc] initWithColor:[UIColor HHOrange] title:items[0]];
        [self.botContainerView addSubview:self.firstItem];
        [self.firstItem makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bigIconView.right).offset(20.0f);
            make.bottom.equalTo(self.botContainerView.centerY).offset(-3.0f);
            make.width.equalTo(self.firstItem.label.width).offset(6.0f);
            make.height.equalTo(self.firstItem.label.height);
        }];
        
        self.secItem = [[HHHomePageItemView alloc] initWithColor:[UIColor HHOrange] title:items[1]];
        [self.botContainerView addSubview:self.secItem];
        [self.secItem makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bigIconView.right).offset(110.0f);
            make.bottom.equalTo(self.firstItem.bottom);
            make.width.equalTo(self.secItem.label.width).offset(6.0f);
            make.height.equalTo(self.secItem.label.height);
        }];
        
        self.thirdItem = [[HHHomePageItemView alloc] initWithColor:[UIColor HHOrange] title:items[2]];
        [self.botContainerView addSubview:self.thirdItem];
        [self.thirdItem makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.firstItem.left);
            make.top.equalTo(self.botContainerView.centerY).offset(3.0f);
            make.width.equalTo(self.thirdItem.label.width).offset(6.0f);
            make.height.equalTo(self.thirdItem.label.height);
        }];
        
        self.forthItem = [[HHHomePageItemView alloc] initWithColor:[UIColor HHOrange] title:items[3]];
        [self.botContainerView addSubview:self.forthItem];
        [self.forthItem makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bigIconView.right).offset(110.0f);;
            make.top.equalTo(self.thirdItem.top);
            make.width.equalTo(self.forthItem.label.width).offset(6.0f);
            make.height.equalTo(self.forthItem.label.height);
        }];
        
        self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_h"]];
        [self.botContainerView addSubview:self.arrowView];
        [self.arrowView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.botContainerView.right).offset(-15.0f);
            make.centerY.equalTo(self.botContainerView.centerY);
        }];
        
        UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
        [self.botContainerView addGestureRecognizer:tapRec];
    }
    return self;
}


- (void)viewTapped {
    if (self.tapAction) {
        self.tapAction();
    }
}

@end
