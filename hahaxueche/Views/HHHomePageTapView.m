//
//  HHHomePageTapView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/6/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHHomePageTapView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHHomePageTapView

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:25.0f];
        self.titleLabel.textColor = [UIColor HHOrange];
        [self.titleLabel sizeToFit];
        [self addSubview:self.titleLabel];
        
        self.subTitleLabel = [[UILabel alloc] init];
        self.subTitleLabel.text = subTitle;
        self.subTitleLabel.font = [UIFont systemFontOfSize:18.0f];
        self.subTitleLabel.textColor = [UIColor HHLightTextGray];
        [self.subTitleLabel sizeToFit];
        [self addSubview:self.subTitleLabel];
        
        [self makeConstraints];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)makeConstraints {
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.centerX.equalTo(self.centerX).multipliedBy(0.5f).offset(5.0f);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY).offset(-15.0f);
        make.centerX.equalTo(self.centerX).multipliedBy(1.5f).offset(-5.0f);
    }];
    
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY).offset(15.0f);
        make.centerX.equalTo(self.centerX).multipliedBy(1.5f).offset(-5.0f);
    }];
}

- (void)viewTapped {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
