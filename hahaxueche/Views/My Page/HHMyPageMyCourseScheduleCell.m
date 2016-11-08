//
//  HHMyPageCouponCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/12/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyPageMyCourseScheduleCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHMyPageCoachCell.h"

@implementation HHMyPageMyCourseScheduleCell

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
    self.titleView = [[HHMyPageItemTitleView alloc] initWithTitle:@"课程信息"];
    [self.contentView addSubview:self.titleView];
    
    self.myCourseView = [[HHMyPageItemView alloc] initWitTitle:@"我的课程" showLine:YES];
    self.myCourseView.arrowImageView.hidden = NO;
    self.myCourseView.botLine.hidden = YES;
    [self.contentView addSubview:self.myCourseView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(kTopPadding);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kTitleViewHeight);
    }];
    
    [self.myCourseView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
}

@end
