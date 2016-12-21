//
//  HHGuardCardTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 21/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHGuardCardTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHStudentStore.h"
#import "HHMyPageCoachCell.h"

@implementation HHGuardCardTableViewCell

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
    self.titleView = [[HHMyPageItemTitleView alloc] initWithTitle:@"我的保过卡"];
    [self.contentView addSubview:self.titleView];
    
    self.courseOneFourView = [[HHMyPageItemView alloc] initWitTitle:@"科目一四保过卡" showLine:NO];
    if ([[HHStudentStore sharedInstance].currentStudent isPurchased]) {
        self.courseOneFourView.arrowImageView.hidden = NO;
        self.courseOneFourView.redDot.hidden = YES;
        
    } else {
        self.courseOneFourView.arrowImageView.hidden = NO;
        self.courseOneFourView.redDot.hidden = YES;
    }
    
    [self.contentView addSubview:self.courseOneFourView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(kTopPadding);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kTitleViewHeight);
    }];
    
    [self.courseOneFourView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
}

@end