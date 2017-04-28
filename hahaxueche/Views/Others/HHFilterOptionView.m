//
//  HHFilterOptionView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 28/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHFilterOptionView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHFilterOptionView

- (instancetype)initWithTitle:(NSString *)title selected:(BOOL)selected {
    self = [super init];
    if (self) {
        self.label = [[UILabel alloc] init];
        self.label.text = title;
        self.label.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.label];
        [self.label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(25.0f);
            make.centerY.equalTo(self.centerY);
        }];
        
        self.line = [[UIView alloc] init];
        [self addSubview:self.line];
        [self.line makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.label.left);
            make.width.equalTo(self.width).offset(-50.0f);
            make.bottom.equalTo(self.bottom);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
        
        if (selected) {
            self.line.backgroundColor = [UIColor HHOrange];
            self.label.textColor = [UIColor HHOrange];
        } else {
            self.label.textColor = [UIColor HHLightTextGray];
        }
    }
    return self;
}
@end
