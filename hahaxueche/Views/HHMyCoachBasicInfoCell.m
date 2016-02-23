//
//  HHMyCoachBasicInfoCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyCoachBasicInfoCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHMyPageCoachCell.h"

@implementation HHMyCoachBasicInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor HHBackgroundGary];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.titleView = [[HHMyPageItemTitleView alloc] initWithTitle:@"基本信息"];
    [self.contentView addSubview:self.titleView];
    
    self.phoneNumberView = [[HHMyPageItemView alloc] initWitTitle:@"联系方式" showLine:YES];
    self.phoneNumberView.arrowImageView.hidden = NO;
    [self.contentView addSubview:self.phoneNumberView];
    
    self.addressView = [[HHMyPageItemView alloc] initWitTitle:@"训练场地址" showLine:NO];
    self.addressView.arrowImageView.hidden = NO;
    [self.contentView addSubview:self.addressView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(kTopPadding);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kTitleViewHeight);
    }];
    
    [self.phoneNumberView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
    [self.addressView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumberView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
}

- (void)setupCellWithCoach:(HHCoach *)coach {
    
}

@end
