//
//  HHHomePageGuideView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 15/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHHomePageGuideView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHHomePageGuideView

- (instancetype)init {
    self = [super init];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *titleView = [self buildTitleView];
        [self addSubview:titleView];
        [titleView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.top.equalTo(self.top);
            make.height.mas_equalTo(40.0f);
        }];

        
        for (int i = 0; i < 4; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:button];
            switch (i) {
                case 0: {
                    [button setImage:[UIImage imageNamed:@"card_jiakaoxinzheng"] forState:UIControlStateNormal];
                    [button makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.left).offset(10.0f);
                        make.top.equalTo(titleView.bottom);
                        make.right.equalTo(self.centerX).offset(-5.0f);
                        make.height.mas_equalTo(70.0f);
                    }];
                } break;
                case 1: {
                    [button setImage:[UIImage imageNamed:@"card_xuecheliucheng"] forState:UIControlStateNormal];
                    [button makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.centerX).offset(5.0f);
                        make.top.equalTo(titleView.bottom);
                        make.right.equalTo(self.right).offset(-10.0f);
                        make.height.mas_equalTo(70.0f);
                    }];
                } break;
                case 2: {
                    [button setImage:[UIImage imageNamed:@"card_baomingxuzhi"] forState:UIControlStateNormal];
                    [button makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.left).offset(10.0f);
                        make.top.equalTo(titleView.bottom).offset(80.0f);
                        make.right.equalTo(self.centerX).offset(-5.0f);
                        make.height.mas_equalTo(70.0f);
                    }];
                } break;
                case 3: {
                    [button setImage:[UIImage imageNamed:@"card_jiaxiaopaiming"] forState:UIControlStateNormal];
                    [button makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.centerX).offset(5.0f);
                        make.top.equalTo(titleView.bottom).offset(80.0f);
                        make.right.equalTo(self.right).offset(-10.0f);
                        make.height.mas_equalTo(70.0f);
                    }];
                } break;
                default:
                    break;
            }
            button.tag = i;
            [button addTarget:self action:@selector(itemTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

- (UIView *)buildTitleView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *stickView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stick"]];
    [view addSubview:stickView];
    [stickView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.left.equalTo(view.left).offset(10.0f);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor HHTextDarkGray];
    label.font = [UIFont boldSystemFontOfSize:17.0f];
    label.text = @"学车指南";
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.left.equalTo(stickView.right).offset(5.0f);
    }];
    
    return view;
}

- (void)itemTapped:(UIButton *)button {
    if (self.itemAction) {
        self.itemAction(button.tag);
    }
}

@end
