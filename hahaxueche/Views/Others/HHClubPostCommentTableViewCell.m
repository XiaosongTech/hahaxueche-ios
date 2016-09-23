//
//  HHClubPostCommentTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/23/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHClubPostCommentTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHClubPostCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.avatarView  = [[UIImageView alloc] init];
        self.avatarView.layer.masksToBounds = YES;
        self.avatarView.layer.cornerRadius = 15.0f;
        [self.contentView addSubview:self.avatarView];
        [self.avatarView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.top).offset(10.0f);
            make.left.equalTo(self.contentView.left).offset(15.0f);
            make.width.mas_equalTo(30.0f);
            make.height.mas_equalTo(30.0f);
        }];
        
        self.nameLabel  = [[UILabel alloc] init];
        self.nameLabel.textColor = [UIColor HHLightestTextGray];
        self.nameLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarView.top);
            make.left.equalTo(self.avatarView.right).offset(5.0f);
        }];
        
        self.dateLabel  = [[UILabel alloc] init];
        self.dateLabel.textColor = [UIColor HHLightestTextGray];
        self.dateLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:self.dateLabel];
        [self.dateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.top);
            make.right.equalTo(self.contentView.right).offset(-15.0f);
        }];
        
        self.contentLabel  = [[UILabel alloc] init];
        self.contentLabel.textColor = [UIColor HHLightTextGray];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:self.contentLabel];
        [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.bottom).offset(5.0f);
            make.left.equalTo(self.nameLabel.left);
            make.right.equalTo(self.dateLabel.right);
        }];
        
        
        self.botLine = [[UIView alloc] init];
        self.botLine.backgroundColor = [UIColor HHLightLineGray];
        [self.contentView addSubview:self.botLine];
        [self.botLine makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.bottom);
            make.left.equalTo(self.nameLabel.left);
            make.right.equalTo(self.contentView.right).offset(-15.0f);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
        
        
    }
    return self;
}

@end
