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
    UIView *historyTitleView = [self buildTitleView];
    [self addSubview:historyTitleView];
    [historyTitleView  makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(40.0f);
    }];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(0, self.searchHistory.count * 40.0f);
    [self addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(historyTitleView.bottom);
        make.width.equalTo(self.width);
        make.left.equalTo(self.left);
        make.bottom.equalTo(self.bottom).offset(-40.0f);
    }];
    
    int i = 0;
    for (NSString *keyword in self.searchHistory) {
        if(i > 3) {
            break;
        }
        UIView *view = [self buildViewWithTag:i title:keyword color:[UIColor HHLightTextGray]];
        [self.scrollView addSubview:view];
        [view  makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.top).offset(i * 40);
            make.left.equalTo(self.scrollView.left).offset(15.0f);
            make.width.equalTo(self.scrollView.width).offset(-15.0f);
            make.height.mas_equalTo(40.0f);
        }];
        [self.views addObject:view];
        i++;
    }
    
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearButton setTitle:@"清除历史记录" forState:UIControlStateNormal];
    self.clearButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.clearButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
    self.clearButton.layer.cornerRadius = 5.0f;
    self.clearButton.layer.borderColor = [UIColor HHOrange].CGColor;
    self.clearButton.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
    [self.clearButton addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.clearButton];
    
    [self.clearButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom);
        make.centerX.equalTo(self.centerX);
        make.height.mas_equalTo(30.0f);
        make.width.mas_equalTo(120.0f);
    }];

    
}


- (UIView *)buildViewWithTag:(NSInteger)tag title:(NSString *)title color:(UIColor *)color {
    UIView *view = [[UIView alloc] init];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_fangdajing"]];
    [view addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(15.0f);
        make.centerY.equalTo(view.centerY);
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    view.tag = tag;
    titleLabel.text = title;
    titleLabel.textColor = color;
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.right).offset(5.0f);
        make.centerY.equalTo(view.centerY);
    }];
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor HHLightLineGray];
    [view addSubview:line];
    
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(15.0f);
        make.bottom.equalTo(view.bottom);
        make.width.equalTo(view.width).offset(-15.0f);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keywordTapped:)];
    [view addGestureRecognizer:recognizer];
    return view;
    
}

- (UIView *)buildTitleView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"搜索历史";
    label.textColor = [UIColor HHTextDarkGray];
    label.font = [UIFont systemFontOfSize:15.0f];
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.top).offset(20.0f);
        make.left.equalTo(view.left).offset(15.0f);
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

- (void)clearHistory {
    if (self.keywordRemoveBlock) {
        self.keywordRemoveBlock();
    }
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
