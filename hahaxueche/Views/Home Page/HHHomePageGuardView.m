//
//  HHHomePageGuardView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 15/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHHomePageGuardView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHHomePageGuardView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *titleView = [self buildTitleView];
        [self addSubview:titleView];
        [titleView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.top.equalTo(self.top);
            make.height.mas_equalTo(40.0f);
        }];
        
        for (int i = 0; i < 3; i++) {
            UIView *view = [self buildItemViewWithIndex:i];
            view.tag = i;
            UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapped:)];
            [view addGestureRecognizer:rec];
            [self addSubview:view];
            [view makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.equalTo(self.left).offset(20.0f);
                } else if (i == 1) {
                    make.centerX.equalTo(self.centerX);
                } else {
                    make.right.equalTo(self.right).offset(-20.0f);
                }
                
                make.top.equalTo(titleView.bottom);
                make.width.mas_equalTo(90.0f);
                make.bottom.equalTo(self.bottom).offset(-10.0f);
            }];
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
    label.text = @"学车保障";
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.left.equalTo(stickView.right).offset(5.0f);
    }];
    
    return view;
}

- (UIView *)buildItemViewWithIndex:(NSInteger)index {
    UIView *view = [[UIView alloc] init];
    
    UIImage *img;
    NSString *title;
    NSString *subTitle;
    NSString *subTitle2;
    
    if (index == 0) {
        img = [UIImage imageNamed:@"ic_xuechebaby"];
        title = @"学车宝";
        subTitle = @"分阶段打款";
        subTitle2 = @"不满意不打款";
    } else if (index == 1) {
        img = [UIImage imageNamed:@"ic_peifubaby"];
        title = @"赔付宝";
        subTitle = @"不过包赔付";
        subTitle2 = @"挂一科赔一颗";
    } else {
        img = [UIImage imageNamed:@"ic_fenqibaby"];
        title = @"分期宝";
        subTitle = @"分期学车";
        subTitle2 = @"30天零利息";
    }
    
    UIImageView * imgView = [[UIImageView alloc] initWithImage:img];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.top).offset(10.0f);
        make.width.equalTo(view.width).offset(-20.0f);
        make.height.equalTo(view.height).multipliedBy(1.0f/2.0f);
        make.centerX.equalTo(view.centerX);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.textColor = [UIColor HHTextDarkGray];
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [view addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.bottom).offset(5.0f);
        make.centerX.equalTo(view.centerX);
    }];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.text = subTitle;
    subTitleLabel.textColor = [UIColor HHLightTextGray];
    subTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:subTitleLabel];
    [subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.bottom).offset(3.0f);
        make.centerX.equalTo(view.centerX);
    }];
    
    
    UILabel *subTitleLabel2 = [[UILabel alloc] init];
    subTitleLabel2.textAlignment = NSTextAlignmentCenter;
    subTitleLabel2.text = subTitle2;
    subTitleLabel2.textColor = [UIColor HHLightTextGray];
    subTitleLabel2.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:subTitleLabel2];
    [subTitleLabel2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subTitleLabel.bottom).offset(3.0f);
        make.centerX.equalTo(view.centerX);
    }];

    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5.0f;
    view.layer.borderColor = [UIColor HHLightLineGray].CGColor;
    view.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
    return view;
}

- (void)itemTapped:(UITapGestureRecognizer *)rec {
    UIView *view = rec.view;
    if (self.itemAction) {
        self.itemAction(view.tag);
    }
}

@end
