//
//  HHOkButtonView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHOkButtonView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@implementation HHOkButtonView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.okButton setTitle:@"我知道了" forState:UIControlStateNormal];
        [self.okButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
        self.okButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.okButton addTarget:self action:@selector(okButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.okButton];
        
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.line];
        
        [self.line makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
        
        [self.okButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line.bottom);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.bottom.equalTo(self.bottom);
        }];
    }
    return self;
}

- (void)okButtonTapped {
    if (self.okAction) {
        self.okAction();
    }
}

@end
