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
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.textColor = [UIColor HHLightTextGray];
        label.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:label];
        
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.right.equalTo(self.centerX);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [self addSubview:imgView];
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(label.right).offset(5.0f);
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
        UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
        [self addGestureRecognizer:tapRec];
        
    }
    return self;
}

- (void)tapped {
    
}

@end
