//
//  HHSearchHistoryListView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 5/24/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHSearchHistoryListView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"


@implementation HHSearchHistoryListView

- (instancetype)initWithHistory:(NSArray *)searchHistory {
    self = [super init];
    if (self) {
        self.searchHistory = searchHistory;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    UIView *historyTitleView = [self buildViewWithTag:-1 title:@"历史记录" color:[UIColor HHLightestTextGray]];
    [self addSubview:historyTitleView];
    [historyTitleView  makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(40.0f);
    }];
    int i = 0;
    for (NSString *keyword in self.searchHistory) {
        if(i > 3) {
            break;
        }
        UIView *view = [self buildViewWithTag:i title:keyword color:[UIColor HHTextDarkGray]];
        [self addSubview:view];
        [view  makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(historyTitleView.bottom).offset(i * 40);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(40.0f);
        }];
        i++;
    }
}


- (UIView *)buildViewWithTag:(NSInteger)tag title:(NSString *)title color:(UIColor *)color {
    UIView *view = [[UIView alloc] init];
    UILabel *titleLabel = [[UILabel alloc] init];
    view.tag = tag;
    titleLabel.text = title;
    titleLabel.textColor = color;
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [view addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(15.0f);
        make.centerY.equalTo(view.centerY);
    }];
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor HHLightLineGray];
    [view addSubview:line];
    
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left);
        make.bottom.equalTo(view.bottom);
        make.width.equalTo(view.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    return view;
    
}


@end
