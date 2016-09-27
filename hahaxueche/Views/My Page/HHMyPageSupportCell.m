//
//  HHMyPageSupportCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyPageSupportCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHMyPageCoachCell.h"

@implementation HHMyPageSupportCell

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
    self.titleView = [[HHMyPageItemTitleView alloc] initWithTitle:@"学车顾问"];
    [self.contentView addSubview:self.titleView];
    
    self.supportOnlineView = [[HHMyPageItemView alloc] initWitTitle:@"在线客服" showLine:YES];
    self.supportOnlineView.arrowImageView.hidden = NO;
    [self.contentView addSubview:self.supportOnlineView];
    
    self.myAdvisorView = [[HHMyPageItemView alloc] initWitTitle:@"我的顾问" showLine:NO];
    self.myAdvisorView.arrowImageView.hidden = NO;
    [self.contentView addSubview:self.myAdvisorView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(kTopPadding);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kTitleViewHeight);
    }];
    
    [self.supportOnlineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
    [self.myAdvisorView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.supportOnlineView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
}

@end
