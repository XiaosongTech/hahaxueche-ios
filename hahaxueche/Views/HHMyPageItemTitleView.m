//
//  HHMyPageItemTitleView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyPageItemTitleView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHMyPageItemTitleView

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor HHOrange];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.titleLabel];
        
        self.botLine = [[UIView alloc] init];
        self.botLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.botLine];
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(15.0f);
        make.centerY.equalTo(self.centerY);
    }];
    
    [self.botLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.bottom.equalTo(self.bottom);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];

}

@end
