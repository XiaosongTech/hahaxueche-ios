//
//  HHMyCoachCourseInfoCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyCoachCourseInfoCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHMyPageCoachCell.h"

@implementation HHMyCoachCourseInfoCell

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
    
    self.licenseTypeView = [[HHMyPageItemView alloc] initWitTitle:@"课程类型" showLine:YES];
    [self.contentView addSubview:self.licenseTypeView];
    
    self.courseTypesView = [[HHMyPageItemView alloc] initWitTitle:@"教授科目" showLine:YES];
    [self.contentView addSubview:self.courseTypesView];
    
    self.feeTypeView = [[HHMyPageItemView alloc] initWitTitle:@"培训费类型" showLine:YES];
    [self.contentView addSubview:self.feeTypeView];
    
    self.feeDetailView = [[HHMyPageItemView alloc] initWitTitle:@"费用及明细" showLine:NO];
    self.feeDetailView.arrowImageView.hidden = NO;
    [self.contentView addSubview:self.feeDetailView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(kTopPadding);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kTitleViewHeight);
    }];
    
    [self.licenseTypeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
    [self.courseTypesView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.licenseTypeView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
    [self.feeTypeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.courseTypesView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
    
    [self.feeDetailView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feeTypeView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
}

- (void)setupCellWithCoach:(HHCoach *)coach {
    
}

@end
