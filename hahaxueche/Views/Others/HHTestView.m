//
//  HHTestView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/9/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHTestView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@interface HHTestView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLbel;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation HHTestView

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image showVerticalLine:(BOOL)showVerticalLine showBottomLine:(BOOL)showBottomLine {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.imgView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:self.imgView];
        
        self.titleLbel = [[UILabel alloc] init];
        self.titleLbel.text = title;
        self.titleLbel.textColor = [UIColor HHLightTextGray];
        self.titleLbel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:self.titleLbel];
        
        [self.imgView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.centerY);
            make.centerX.equalTo(self.centerX);
        }];
        
        [self.titleLbel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.centerY).offset(5.0f);
            make.centerX.equalTo(self.centerX);
        }];
        
        if (showBottomLine) {
            self.bottomLine = [[UIView alloc] init];
            self.bottomLine.backgroundColor = [UIColor HHLightLineGray];
            [self addSubview:self.bottomLine];
            
            [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.bottom);
                make.left.equalTo(self.left);
                make.width.equalTo(self.width);
                make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
            }];
        }
        
        if (showVerticalLine) {
            self.verticalLine = [[UIView alloc] init];
            self.verticalLine.backgroundColor = [UIColor HHLightLineGray];
            [self addSubview:self.verticalLine];
            
            [self.verticalLine makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.centerY);
                make.right.equalTo(self.right);
                make.width.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
                make.height.equalTo(self.height).offset(-30.0f);
            }];
        }
        
    }
    return self;
}

@end
