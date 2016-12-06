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

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor HHLightTextGray];
        self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.titleLabel sizeToFit];
        [self addSubview:self.titleLabel];
        
        [self makeConstraints];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)makeConstraints {
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(10.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom).offset(-5.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
}

- (void)viewTapped {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
