//
//  HHHomePageSupportView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/20/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHHomePageSupportView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHHomePageSupportView

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title  showRightLine:(BOOL)showRightLine {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor HHLightTextGray];
        self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.titleLabel sizeToFit];
        [self addSubview:self.titleLabel];
        
        
        self.rightLine = [[UIView alloc] init];
        self.rightLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.rightLine];
        
        if (showRightLine) {
            self.rightLine.hidden = NO;
        } else {
            self.rightLine.hidden = YES;
        }
        
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.bottomLine];
        
        [self makeConstraints];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)makeConstraints {
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.centerX.equalTo(self.centerX).multipliedBy(0.4f);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.centerX.equalTo(self.centerX).multipliedBy(1.2f);
    }];
    
    [self.rightLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.right.equalTo(self.right);
        make.width.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        make.height.equalTo(self.height);
    }];
    
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
}

- (void)viewTapped {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
