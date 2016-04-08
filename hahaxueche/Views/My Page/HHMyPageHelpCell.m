//
//  HHMyPageHelpCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyPageHelpCell.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHMyPageCoachCell.h"

@implementation HHMyPageHelpCell

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
    self.titleView = [[HHMyPageItemTitleView alloc] initWithTitle:@"使用帮助"];
    [self.contentView addSubview:self.titleView];
    
    self.aboutView = [[HHMyPageItemView alloc] initWitTitle:@"关于小哈" showLine:YES];
    self.aboutView.arrowImageView.hidden = NO;
    [self.contentView addSubview:self.aboutView];
    
    self.appInfoView = [[HHMyPageItemView alloc] initWitTitle:@"软件信息" showLine:YES];
    self.appInfoView.arrowImageView.hidden = NO;
    [self.contentView addSubview:self.appInfoView];
    
    self.rateUsView = [[HHMyPageItemView alloc] initWitTitle:@"支持小哈" showLine:NO];
    self.rateUsView.arrowImageView.hidden = NO;
    [self.contentView addSubview:self.rateUsView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(kTopPadding);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kTitleViewHeight);
    }];

    [self.aboutView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
    
    [self.appInfoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aboutView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
    
    [self.rateUsView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appInfoView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
    

}

@end
