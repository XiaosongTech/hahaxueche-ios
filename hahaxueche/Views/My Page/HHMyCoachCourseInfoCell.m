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
    self.titleView = [[HHMyPageItemTitleView alloc] initWithTitle:@"班别信息"];
    [self.contentView addSubview:self.titleView];
    
    self.classTypeView = [[HHMyPageItemView alloc] initWitTitle:@"购买班别" showLine:YES];
    [self.contentView addSubview:self.classTypeView];
    
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
    
    [self.classTypeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
    
    [self.feeDetailView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classTypeView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
}

- (void)setupCellWithStudent:(HHStudent *)student {
    self.classTypeView.valueLabel.text = [student getPurchasedProductName];
}

@end
