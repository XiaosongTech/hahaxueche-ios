//
//  HHEmptyScheduleCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/17/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHEmptyScheduleCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHEmptyScheduleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor HHBackgroundGary];
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor HHLightTextGray];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.titleLabel];
        
        self.iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_nolist_bk_pic"]];
        [self.contentView addSubview:self.iconView];
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.centerX);
        make.centerY.equalTo(self.contentView.centerY).offset(-60.0f);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.centerX);
        make.centerY.equalTo(self.contentView.centerY).offset(20.0f);
        make.width.equalTo(self.contentView.width).offset(-40.0f);
    }];
}

- (void)setupCellWithTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
