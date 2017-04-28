//
//  HHFilterItemView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 27/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHFilterItemView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHFilterItemView

- (instancetype)initWithTitle:(NSString *)title rightLine:(BOOL)rightLine {
    self = [super init];
    if (self) {
        
        self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_arrow_gray"]];
        [self addSubview:self.imgView];
        [self.imgView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.right.equalTo(self.right).offset(-15.0f);
        }];
        
        self.label = [[UILabel alloc] init];
        self.label.text = title;
        self.label.textColor = [UIColor HHLightTextGray];
        self.label.font = [UIFont systemFontOfSize:14.0f];
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.numberOfLines = 1;
        [self addSubview:self.label];
        
        [self.label makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.left).offset(20.0f);
            make.right.lessThanOrEqualTo(self.imgView.left);
        }];
        
        
        if (rightLine) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor HHLightLineGray];
            [self addSubview:line];
            [line makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.right);
                make.centerY.equalTo(self.centerY);
                make.height.equalTo(self.height).multipliedBy(0.5f);
                make.width.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
            }];
        }
        
        UIView *botLine = [[UIView alloc] init];
        botLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:botLine];
        [botLine makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.bottom.equalTo(self.bottom);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
        
        self.userInteractionEnabled = YES;
        
    }
    return self;
}


@end
