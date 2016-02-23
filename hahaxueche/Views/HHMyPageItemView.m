//
//  HHMyPageItemView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyPageItemView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@implementation HHMyPageItemView

- (instancetype)initWitTitle:(NSString *)title showLine:(BOOL)showLine {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor HHLightTextGray];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:self.titleLabel];
        
        self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_more_arrow"]];
        self.arrowImageView.hidden = YES;
        [self addSubview:self.arrowImageView];
        
        self.valueLabel = [[UILabel alloc] init];
        self.valueLabel.textColor = [UIColor HHOrange];
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        self.valueLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:self.valueLabel];
        
        
        self.botLine = [[UIView alloc] init];
        self.botLine.backgroundColor = [UIColor HHLightLineGray];
        self.botLine.hidden = !showLine;
        [self addSubview:self.botLine];
        
        [self makeConstraints];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)makeConstraints {
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.left.equalTo(self.left).offset(15.0f);
    }];
    
    [self.arrowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.right.equalTo(self.right).offset(-15.0f);
    }];
    
    [self.valueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.right.equalTo(self.arrowImageView).offset(-5.0f);
        make.left.equalTo(self.titleLabel.right).offset(20.0f);
    }];
    
    [self.botLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.bottom.equalTo(self.bottom);
        make.right.equalTo(self.right);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
}

- (void)viewTapped {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
