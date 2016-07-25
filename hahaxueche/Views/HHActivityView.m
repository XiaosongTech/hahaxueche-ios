//
//  HHActivityView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/25/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHActivityView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHActivityView

- (instancetype)initWithActivity:(HHActivity *)activity fullLine:(BOOL)fullLine {
    self = [super init];
    if (self) {
        self.activity = activity;
        self.fullLine = fullLine;
        self.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_activity_tuan"]];
    [self addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"徐东$2580团购";
    self.titleLabel.textColor = [UIColor HHLightDarkTextGray];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.textColor = [UIColor HHOrange];
    self.subTitleLabel.text = @"查看详情 >>";
    self.subTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:self.subTitleLabel];
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.textColor = [UIColor HHLightTextGray];
    self.rightLabel.text = @"距活动截止还剩:";
    self.rightLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:self.rightLabel];
    
    self.countDownLabel = [[UILabel alloc] init];
    [self addSubview:self.countDownLabel];
    
    self.botLine = [[UIView alloc] init];
    self.botLine.backgroundColor = [UIColor HHLightLineGray];
    [self addSubview:self.botLine];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.left.equalTo(self.left).offset(15.0f);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.centerY).offset(-2.0f);
        make.left.equalTo(self.imageView.right).offset(10.0f);
    }];
    
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerY).offset(2.0f);
        make.left.equalTo(self.titleLabel.left);
    }];
    
    [self.rightLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.centerY).offset(-2.0f);
        make.right.equalTo(self.right).offset(-15.0f);
    }];
    
    [self.countDownLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerY).offset(2.0f);
        make.right.equalTo(self.rightLabel.right);
    }];
    
    if (self.fullLine) {
        [self.botLine makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
        
    } else {
        [self.botLine makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom);
            make.left.equalTo(self.imageView.left);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
    }
}

@end
