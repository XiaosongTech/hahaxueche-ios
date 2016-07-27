//
//  HHActivityView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/25/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHEventView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import <UIImageView+WebCache.h>
#import "HHWebViewController.h"

@implementation HHEventView

- (instancetype)initWithEvent:(HHEvent *)event fullLine:(BOOL)fullLine {
    self = [super init];
    if (self) {
        self.event = event;
        self.fullLine = fullLine;
        self.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.layer.cornerRadius = 20.0f;
    self.imageView.layer.masksToBounds = YES;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.event.icon] placeholderImage:nil];
    [self addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.event.title;
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
    
    self.countDownView = [[HHCountDownView alloc] initWithStartDate:[NSDate date] finishDate:self.event.endDate numberColor:[UIColor HHOrange] textColor:[UIColor HHLightTextGray] numberFont:[UIFont systemFontOfSize:15.0f] textFont:[UIFont systemFontOfSize:12.0f]];
    [self addSubview:self.countDownView];
    
    self.botLine = [[UIView alloc] init];
    self.botLine.backgroundColor = [UIColor HHLightLineGray];
    [self addSubview:self.botLine];
    
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showWebView)];
    [self addGestureRecognizer:rec];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.left.equalTo(self.left).offset(15.0f);
        make.width.mas_equalTo(40.0f);
        make.height.mas_equalTo(40.0f);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.centerY);
        make.left.equalTo(self.imageView.right).offset(10.0f);
    }];
    
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerY).offset(5.0f);
        make.left.equalTo(self.titleLabel.left);
    }];
    
    [self.rightLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.centerY).offset(-5.0f);
        make.right.equalTo(self.right).offset(-15.0f);
    }];
    
    [self.countDownView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerY);
        make.right.equalTo(self.rightLabel.right);
        make.width.mas_equalTo(120.0f);
        make.height.mas_equalTo(20.0f);
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

- (void)showWebView {
    if (self.eventBlock) {
        self.eventBlock(self.event);
    }
}

@end
