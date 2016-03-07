//
//  HHMyPageHelpCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyPageHelpCell.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHMyPageCoachCell.h"

@implementation HHMyPageHelpCell

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
    self.titleView = [[HHMyPageItemTitleView alloc] initWithTitle:@"使用帮助"];
    [self.contentView addSubview:self.titleView];
    
    self.FAQView = [[HHMyPageItemView alloc] initWitTitle:@"学员常见问题" showLine:YES];
    self.FAQView.arrowImageView.hidden = NO;
    [self.contentView addSubview:self.FAQView];
    
    self.aboutView = [[HHMyPageItemView alloc] initWitTitle:@"关于哈哈学车" showLine:NO];
    self.aboutView.arrowImageView.hidden = NO;
    [self.contentView addSubview:self.aboutView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(kTopPadding);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kTitleViewHeight);
    }];
    
//    [self.FAQView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.titleView.bottom);
//        make.left.equalTo(self.left);
//        make.width.equalTo(self.width);
//        make.height.mas_equalTo(kItemViewHeight);
//        
//    }];
    [self.aboutView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight);
        
    }];
}

@end
