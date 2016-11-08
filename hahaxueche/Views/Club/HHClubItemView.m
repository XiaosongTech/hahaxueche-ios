//
//  HHClubItemView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/20/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHClubItemView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHClubItemView

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title subTitle:(NSString *)subTitle showRightLine:(BOOL)showRightLine showBotLine:(BOOL)showBotLine {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.imgView = [[UIImageView alloc] initWithImage:icon];
        [self addSubview:self.imgView];
        [self.imgView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.centerX.equalTo(self.centerX).multipliedBy(0.5f);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor HHTextDarkGray];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [self addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.centerY).offset(-2.0f);
            make.left.equalTo(self.imgView.right).offset(5.0f);
        }];
        
        self.subTitleLabel = [[UILabel alloc] init];
        self.subTitleLabel.text = subTitle;
        self.subTitleLabel.textColor = [UIColor HHLightTextGray];
        self.subTitleLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.subTitleLabel];
        [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.centerY).offset(2.0f);
            make.left.equalTo(self.titleLabel.left);
        }];
        
        if (showRightLine) {
            UIView *rightLine = [[UIView alloc] init];
            rightLine.backgroundColor = [UIColor HHLightLineGray];
            [self addSubview:rightLine];
            [rightLine makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.right);
                make.top.equalTo(self.top);
                make.height.equalTo(self.height);
                make.width.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
            }];

        }
        
        if (showBotLine) {
            UIView *botLine = [[UIView alloc] init];
            botLine.backgroundColor = [UIColor HHLightLineGray];
            [self addSubview:botLine];
            [botLine makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.bottom);
                make.left.equalTo(self.left);
                make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
                make.width.equalTo(self.width);
            }]; 
        }
        
        UITapGestureRecognizer *tagRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
        [self addGestureRecognizer:tagRec];
       
    }
    
    return self;
}

- (void)viewTapped {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
