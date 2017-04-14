//
//  HHHomePageItemsView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 12/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHHomePageItemsView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHHomePageItemsView

- (instancetype)init {
    self = [super init];
    if (self) {
        for (int i = 0; i < 4; i++) {
            UIView *view;
            if (i == 0) {
                view = [self buildItmeViewWithImage:[UIImage imageNamed:@"ic_mapsearch"] title:@"地图查找"];
                
            } else if (i == 1) {
                view = [self buildItmeViewWithImage:[UIImage imageNamed:@"ic_schoolsale"] title:@"驾校团购"];
                
            } else if (i == 2) {
                view = [self buildItmeViewWithImage:[UIImage imageNamed:@"ic_questionbank"] title:@"在线题库"];
                
            } else {
                view = [self buildItmeViewWithImage:[UIImage imageNamed:@"ic_customerservice"] title:@"在线客服"];
                
            }
            view.tag = i;
            [self addSubview:view];
            UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapped:)];
            [view addGestureRecognizer:rec];
            [view makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.centerX).multipliedBy((1+2*i) * 0.25f);
                make.top.equalTo(self.top);
                make.width.equalTo(self.width).multipliedBy(0.25f);
                make.height.equalTo(self.height);
            }];
        }
        
    }
    return self;
}

- (UIView *)buildItmeViewWithImage:(UIImage *)image title:(NSString *)title {
    UIView *view = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [view addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.centerX);
        make.top.equalTo(view.top).offset(15.0f);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = [UIColor HHLightTextGray];
    label.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.centerX);
        make.bottom.equalTo(view.bottom).offset(-10.0f);
    }];
    
    return view;
}

- (void)itemTapped:(UITapGestureRecognizer *)rec {
    UIView *view = rec.view;
    
}

@end
