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
    self.titleView = [[HHMyPageItemTitleView alloc] initWithTitle:@"联系客服"];
    [self.contentView addSubview:self.titleView];
    
    self.supportQQView = [[HHMyPageItemView alloc] initWitTitle:@"客服QQ" showLine:YES];
    self.supportQQView.arrowImageView.hidden = NO;
    [self.contentView addSubview:self.supportQQView];
    
    self.supportNumberView = [[HHMyPageItemView alloc] initWitTitle:@"客服热线" showLine:NO];
    self.supportNumberView.arrowImageView.hidden = NO;
    [self.contentView addSubview:self.supportNumberView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(kTopPadding);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kTitleViewHeight);
    }];
    
    [self.supportQQView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
    [self.supportNumberView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.supportQQView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
}

@end