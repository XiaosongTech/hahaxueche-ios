//
//  HHMyPageReferCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/25/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyPageReferCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHMyPageCoachCell.h"

@implementation HHMyPageReferCell

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
    self.titleView = [[HHMyPageItemTitleView alloc] initWithTitle:@"推荐有奖"];
    [self.contentView addSubview:self.titleView];
    
    self.referFriendsView = [[HHMyPageItemView alloc] initWitTitle:@"推荐好友" showLine:YES];
    self.referFriendsView.arrowImageView.hidden = NO;
    [self.contentView addSubview:self.referFriendsView];
    
    self.myBonusView = [[HHMyPageItemView alloc] initWitTitle:@"已赚取" showLine:NO];
    self.myBonusView.arrowImageView.hidden = NO;
    [self.contentView addSubview:self.myBonusView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(kTopPadding);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kTitleViewHeight);
    }];
    
    [self.referFriendsView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
    [self.myBonusView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.referFriendsView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
}

@end