//
//  HHMyPageCoachCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyPageCoachCell.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@implementation HHMyPageCoachCell

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
    self.titleView = [[HHMyPageItemTitleView alloc] initWithTitle:@"教练信息"];
    [self.contentView addSubview:self.titleView];
    
    self.myCoachView = [[HHMyPageItemView alloc] initWitTitle:@"我的教练" showLine:YES];
    self.myCoachView.arrowImageView.hidden = NO;
    [self.contentView addSubview:self.myCoachView];
    
    self.followedCoachView = [[HHMyPageItemView alloc] initWitTitle:@"我关注的教练" showLine:NO];
    self.followedCoachView.arrowImageView.hidden = NO;
    [self.contentView addSubview:self.followedCoachView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(kTopPadding);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kTitleViewHeight);
        
    }];
    
    [self.myCoachView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
    
    [self.followedCoachView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myCoachView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];

}

- (void)setupCellWithCoach:(HHCoach *)coach coachList:(NSArray *)coachList {
}

@end
