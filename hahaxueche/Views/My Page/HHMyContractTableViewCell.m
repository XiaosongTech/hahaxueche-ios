//
//  HHMyContractTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 23/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyContractTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHMyPageCoachCell.h"
#import "HHStudentStore.h"

@implementation HHMyContractTableViewCell

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
    self.titleView = [[HHMyPageItemTitleView alloc] initWithTitle:@"学员协议"];
    [self.contentView addSubview:self.titleView];
    
    self.myContractView = [[HHMyPageItemView alloc] initWitTitle:@"我的协议" showLine:NO];
    if ([[HHStudentStore sharedInstance].currentStudent isPurchased]) {
        if ([HHStudentStore sharedInstance].currentStudent.agreementURL && ![[HHStudentStore sharedInstance].currentStudent.agreementURL isEqualToString:@""] ) {
            self.myContractView.arrowImageView.hidden = NO;
            self.myContractView.redDot.hidden = YES;
        } else {
            self.myContractView.arrowImageView.hidden = YES;
            self.myContractView.redDot.hidden = NO;
        }
        
    } else {
        self.myContractView.arrowImageView.hidden = NO;
        self.myContractView.redDot.hidden = YES;
    }

    [self.contentView addSubview:self.myContractView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(kTopPadding);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kTitleViewHeight);
    }];
    
    [self.myContractView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
}




@end
