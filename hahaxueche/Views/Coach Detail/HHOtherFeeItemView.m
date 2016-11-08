//
//  HHOtherFeeItemView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 25/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHOtherFeeItemView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@implementation HHOtherFeeItemView

- (instancetype)initWithTitle:(NSString *)title text:(NSMutableAttributedString *)text {
    self = [super init];
    if (self) {
        self.stickView = [[UIView alloc] init];
        self.stickView.backgroundColor = [UIColor HHOrange];
        [self addSubview:self.stickView];
        [self.stickView makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(5.0f);
            make.height.mas_equalTo(20.0f);
            make.left.equalTo(self.left);
            make.top.equalTo(self.top);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor HHLightTextGray];
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.stickView.right).offset(8.0f);
            make.centerY.equalTo(self.stickView.centerY);
        }];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.numberOfLines = 0;
        self.textLabel.attributedText = text;
        [self addSubview:self.textLabel];
        [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.stickView.left);
            make.top.equalTo(self.stickView.bottom).offset(10.0f);
            make.width.equalTo(self.width);
        }];
    }
    return self;
}
@end
