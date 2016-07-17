//
//  HHMyPageCouponCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/12/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyPageCouponCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHMyPageCoachCell.h"

@implementation HHMyPageCouponCell

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
    self.titleView = [[HHMyPageItemTitleView alloc] initWithTitle:@"优惠券"];
    [self.contentView addSubview:self.titleView];
    
    self.myCouponView = [[HHMyPageItemView alloc] initWitTitle:@"我的优惠券" showLine:YES];
    self.myCouponView.arrowImageView.hidden = NO;
    self.myCouponView.botLine.hidden = YES;
    [self.contentView addSubview:self.myCouponView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(kTopPadding);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kTitleViewHeight);
    }];
    
    [self.myCouponView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
}

@end
