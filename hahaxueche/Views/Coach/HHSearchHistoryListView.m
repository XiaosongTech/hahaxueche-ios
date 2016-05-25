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
        self.views = [NSMutableArray array];
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
        [self.views addObject:view];
        i++;
    }
    
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearButton setTitle:@"清除历史记录" forState:UIControlStateNormal];
    self.clearButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.clearButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
    self.clearButton.layer.cornerRadius = 5.0f;
    self.clearButton.layer.borderColor = [UIColor HHOrange].CGColor;
    self.clearButton.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
    [self.clearButton addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.clearButton];
    
    UIView *lastView = [self.views lastObject];
    if (lastView) {
        [self.clearButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.bottom).offset(10.0f);
            make.centerX.equalTo(self.centerX);
            make.height.mas_equalTo(35.0f);
            make.width.mas_equalTo(120.0f);
        }];
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
    
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keywordTapped:)];
    [view addGestureRecognizer:recognizer];
    return view;
    
}

- (void)clearHistory {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSMutableArray array] forKey:@"coachSearchKeywords"];
    for (UIView *view in self.views) {
        [view removeFromSuperview];
    }
    [self.clearButton removeFromSuperview];
}

- (void)keywordTapped:(UITapGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;
    if (view.tag > -1) {
        if (self.keywordBlock) {
            self.keywordBlock(self.searchHistory[view.tag]);
        }
    }
    
}


@end
