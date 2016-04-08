//
//  HHCoachScheduleCellTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/8/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachScheduleCellTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHCoachScheduleCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftView = [[UIView alloc] init];
        self.leftView.backgroundColor = [UIColor HHBackgroundGary];
        [self.contentView addSubview:self.leftView];
        
        self.stickView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_class_list"]];
        [self.leftView addSubview:self.stickView];
        
        self.dateLabel = [[UILabel alloc] init];
        [self.leftView addSubview:self.dateLabel];
        
        self.rightView = [[UIView alloc] init];
        self.rightView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.rightView];
        
        self.botLine = [[UIView alloc] init];
        self.botLine.backgroundColor = [UIColor HHLightLineGray];
        [self.rightView addSubview:self.botLine];
        
        self.botButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.botButton.backgroundColor = [UIColor HHOrange];
        self.botButton.layer.masksToBounds = YES;
        self.botButton.layer.cornerRadius = 5.0f;
        [self.botButton setTitle:@"预约课程" forState:UIControlStateNormal];
        self.botButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.rightView addSubview:self.botButton];
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    [self.leftView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.width.mas_equalTo(60.0f);
        make.top.equalTo(self.contentView.top);
        make.height.equalTo(self.contentView.height);
    }];
    
    [self.rightView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.right);
        make.width.equalTo(self.contentView.width).offset(-60.0f);
        make.top.equalTo(self.contentView.top);
        make.height.equalTo(self.contentView.height);
    }];
    
    [self.stickView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.left);
        make.top.equalTo(self.leftView.top).offset(25.0f);
    }];
    
    [self.botLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.rightView.bottom);
        make.left.equalTo(self.rightView.left);
        make.width.equalTo(self.rightView.width);
        make.height.mas_equalTo(2.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.botButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.rightView.bottom).offset(-30.0f);
        make.centerX.equalTo(self.rightView.centerX);
        make.width.equalTo(self.rightView.width).offset(-60.0f);
        make.height.mas_equalTo(35.0f);
        
    }];
    
    
}

@end
