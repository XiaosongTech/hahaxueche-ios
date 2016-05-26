//
//  HHPaymentMethodView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 5/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPaymentMethodView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@implementation HHPaymentMethodView

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle icon:(UIImage *)image selected:(BOOL)selected enabled:(BOOL)enabled {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.enabled = enabled;
        self.selected = selected;
        
        self.iconView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:self.iconView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:self.titleLabel];
        
        self.subTitleLabel = [[UILabel alloc] init];
        self.subTitleLabel.text = subTitle;
        self.subTitleLabel.font = [UIFont systemFontOfSize:11.0f];
        [self addSubview:self.subTitleLabel];
        
        self.selectionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_selected_normal"]];
        [self addSubview:self.selectionView];
        
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.bottomLine];
        
        [self.iconView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.left).offset(15.0f);
        }];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY).offset(-10.0f);
            make.left.equalTo(self.iconView.right).offset(10.0f);
        }];
        
        [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY).offset(10.0f);
            make.left.equalTo(self.iconView.right).offset(10.0f);
        }];
        
        [self.selectionView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.right.equalTo(self.right).offset(-15.0f);
        }];
        
        [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
        
        if (self.enabled) {
            self.titleLabel.textColor = [UIColor HHTextDarkGray];
            self.subTitleLabel.textColor = [UIColor HHLightTextGray];
        } else {
            self.titleLabel.textColor = [UIColor HHLightestTextGray];
            self.subTitleLabel.textColor = [UIColor HHLightestTextGray];
        }
        

        if (self.selected) {
            self.selectionView.image = [UIImage imageNamed:@"icon_selected_press"];
        }

    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (self.selected) {
        self.selectionView.image = [UIImage imageNamed:@"icon_selected_press"];
    } else {
        self.selectionView.image = [UIImage imageNamed:@"icon_selected_normal"];
    }
    
}




@end
