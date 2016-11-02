//
//  HHClubPostTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHClubPostTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHFormatUtility.h"
#import <UIImageView+WebCache.h>

@implementation HHClubPostTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.dateLabel = [self buildLabelWithFont:[UIFont systemFontOfSize:12.0f] color:[UIColor HHLightTextGray]];
        [self.contentView addSubview:self.dateLabel];
        [self.dateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.top).offset(17.0f);
            make.left.equalTo(self.contentView.left).offset(12.0f);
        }];
        
        self.typeLabel = [self buildLabelWithFont:[UIFont systemFontOfSize:12.0f] color:[UIColor HHLightTextGray]];
        [self.contentView addSubview:self.typeLabel];
        [self.typeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.dateLabel.centerY);
            make.right.equalTo(self.contentView.right).offset(-12.0f);
        }];
        
        self.imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imgView];
        [self.imgView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.top).offset(34.0f);
            make.left.equalTo(self.contentView.left).offset(12.0f);
            make.width.equalTo(self.contentView.width).offset(-24.0f);
            make.height.mas_equalTo(180.0f);
        }];
        
        
        self.titleLabel = [self buildLabelWithFont:[UIFont boldSystemFontOfSize:18.0f] color:[UIColor HHTextDarkGray]];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.bottom).offset(5.0f);
            make.left.equalTo(self.contentView.left).offset(12.0f);
        }];
        
        self.sepratorView = [[UIView alloc] init];
        self.sepratorView.backgroundColor = [UIColor HHBackgroundGary];
        [self.contentView addSubview:self.sepratorView];
        [self.sepratorView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.bottom);
            make.left.equalTo(self.contentView.left);
            make.width.equalTo(self.contentView.width);
            make.height.mas_equalTo(10.0f);

        }];
        
        self.statView = [[HHClubPostStatView alloc] initWithInteraction:NO];
        [self.contentView addSubview:self.statView];
        [self.statView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.sepratorView.top);
            make.left.equalTo(self.contentView.left);
            make.width.equalTo(self.contentView.width);
            make.height.mas_equalTo(38.0f);
        }];
        
        self.botLine = [[UIView alloc] init];
        self.botLine.backgroundColor = [UIColor HHLightLineGray];
        [self.contentView addSubview:self.botLine];
        [self.botLine makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.statView.top);
            make.left.equalTo(self.contentView.left);
            make.width.equalTo(self.contentView.width);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
        
        
        self.contentLabel = [self buildLabelWithFont:[UIFont boldSystemFontOfSize:12.0f] color:[UIColor HHLightTextGray]];
        self.contentLabel.numberOfLines = 2;
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.bottom).offset(3.0f);
            make.left.equalTo(self.contentView.left).offset(12.0f);
            make.width.equalTo(self.contentView.width).offset(-24.0f);
        }];

        
    }
    return self;
}

- (UILabel *)buildLabelWithFont:(UIFont *)font color:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = textColor;
    label.font = font;
    label.numberOfLines = 0;
    return label;
}

- (void)setupCellWithClubPost:(HHClubPost *)clubPost showType:(BOOL)showType {
    [self.statView setupViewWithClubPost:clubPost];
    self.dateLabel.text = [[HHFormatUtility fullDateFormatter] stringFromDate:clubPost.createdAt];
    if (showType) {
        self.typeLabel.text = [clubPost getCategoryName];
        self.typeLabel.hidden = NO;
    } else {
        self.typeLabel.hidden = YES;
    }
    
    self.titleLabel.text = clubPost.title;
    self.contentLabel.text = clubPost.abstract;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:clubPost.coverImg] placeholderImage:nil];
}

@end
