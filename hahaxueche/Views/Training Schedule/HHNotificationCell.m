//
//  HHNotificationCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHNotificationCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import <UIImageView+WebCache.h>

static NSInteger const kAvaRadius = 25.0f;

@implementation HHNotificationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.avaView = [[UIImageView alloc] init];
        self.avaView.layer.masksToBounds = YES;
        self.avaView.layer.cornerRadius = kAvaRadius;
        [self.contentView addSubview:self.avaView];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = [UIColor HHLightTextGray];
        self.nameLabel.font = [UIFont systemFontOfSize:20.0f];
        [self.contentView addSubview:self.nameLabel];
        
        self.mainLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.mainLabel];
        
        self.botLine = [[UIView alloc] init];
        self.botLine.backgroundColor = [UIColor HHLightLineGray];
        [self.contentView addSubview:self.botLine];
        
        [self.avaView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(15.0f);
            make.centerY.equalTo(self.contentView.centerY);
            make.width.mas_equalTo(kAvaRadius * 2.0f);
            make.height.mas_equalTo(kAvaRadius * 2.0f);
        }];
        
        [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avaView.right).offset(15.0f);
            make.centerY.equalTo(self.contentView.centerY).offset(-12.0f);
        }];
        
        [self.mainLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avaView.right).offset(15.0f);
            make.centerY.equalTo(self.contentView.centerY).offset(12.0f);
        }];
        
        [self.botLine makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avaView.left);
            make.bottom.equalTo(self.contentView.bottom);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
            make.right.equalTo(self.contentView.right);
        }];
    }
    return self;
}

- (void)setupCellWithNotification:(HHNotification *)notification {
    [self.avaView sd_setImageWithURL:[NSURL URLWithString:notification.avaURL] placeholderImage:[UIImage imageNamed:@"ic_coach_ava"]];
    self.nameLabel.text = notification.name;
    self.mainLabel.attributedText = [self buildString:notification];
    
}

- (NSMutableAttributedString *)buildString:(HHNotification *)notification {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:notification.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightestTextGray]}];
    
    for (NSString *highlightString in notification.highlights) {
        NSRange range = [notification.text rangeOfString:highlightString];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor HHOrange] range:range];
    }
    
    return attrString;
}

@end
