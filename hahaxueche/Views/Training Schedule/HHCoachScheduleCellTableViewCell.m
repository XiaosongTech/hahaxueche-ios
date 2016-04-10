//
//  HHCoachScheduleCellTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/8/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachScheduleCellTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import <UIImageView+WebCache.h>

static NSInteger kAvatarRadius = 25.0f;

@implementation HHCoachScheduleCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.leftView = [[UIView alloc] init];
        self.leftView.backgroundColor = [UIColor HHBackgroundGary];
        [self.contentView addSubview:self.leftView];
        
        self.stickView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_class_list"]];
        [self.leftView addSubview:self.stickView];
        
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.numberOfLines = 2;
        [self.leftView addSubview:self.dateLabel];
        
        self.rightView = [[UIView alloc] init];
        self.rightView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.rightView];
        
        self.botLine = [[UIView alloc] init];
        self.botLine.backgroundColor = [UIColor HHLightLineGray];
        [self.rightView addSubview:self.botLine];
        
        self.botButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.botButton.backgroundColor = [UIColor HHOrange];
        self.botButton.layer.masksToBounds = YES;
        self.botButton.layer.cornerRadius = 5.0f;
        [self.botButton setTitle:@"预约课程" forState:UIControlStateNormal];
        self.botButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.botButton addTarget:self action:@selector(bookSchedule) forControlEvents:UIControlEventTouchUpInside];
        [self.rightView addSubview:self.botButton];
        
        self.coachNameLabel = [[UILabel alloc] init];
        self.coachNameLabel.textColor = [UIColor HHLightTextGray];
        self.coachNameLabel.font = [UIFont systemFontOfSize:22.0f];
        [self.rightView addSubview:self.coachNameLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textColor = [UIColor HHLightestTextGray];
        self.timeLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.rightView addSubview:self.timeLabel];
        
        self.otherInfoLabel = [[UILabel alloc] init];
        self.otherInfoLabel.textColor = [UIColor HHOrange];
        self.otherInfoLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.rightView addSubview:self.otherInfoLabel];
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    [self.leftView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.width.mas_equalTo(60.0f);
        make.top.equalTo(self.contentView.top);
        make.height.equalTo(self.contentView.height);
    }];
    
    [self.rightView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.right);
        make.width.equalTo(self.contentView.width).offset(-60.0f);
        make.top.equalTo(self.contentView.top);
        make.height.equalTo(self.contentView.height);
    }];
    
    [self.stickView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.left);
        make.top.equalTo(self.leftView.top).offset(25.0f);
    }];
    
    [self.botLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.rightView.bottom);
        make.left.equalTo(self.rightView.left);
        make.width.equalTo(self.rightView.width);
        make.height.mas_equalTo(2.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.botButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.rightView.bottom).offset(-25.0f);
        make.centerX.equalTo(self.rightView.centerX);
        make.width.equalTo(self.rightView.width).offset(-60.0f);
        make.height.mas_equalTo(35.0f);
        
    }];
    
    [self.dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stickView.right).offset(5.0f);
        make.centerY.equalTo(self.stickView.centerY);
    }];
    
    [self.coachNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightView.left).offset(30.0f);
        make.top.equalTo(self.rightView.top).offset(20.0f);
    }];
    
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coachNameLabel.right).offset(10.0f);
        make.bottom.equalTo(self.coachNameLabel.bottom);
    }];
    
    [self.otherInfoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coachNameLabel.left);
        make.top.equalTo(self.coachNameLabel.bottom).offset(5.0f);
    }];
    
}

- (void)setupCellWithSchedule:(HHCoachSchedule *)schedule showLine:(BOOL)showLine showDate:(BOOL)showDate {
    self.schedule = schedule;
    self.dateLabel.attributedText = [self buildDateString:nil];
    self.coachNameLabel.text = @"李勇";
    self.timeLabel.text = @"(14:30 - 17:30)";
    self.otherInfoLabel.text = @"科目二, 准考, 4人/8人";
    self.botLine.hidden = !showLine;
    self.dateLabel.hidden = !showDate;
    self.stickView.hidden = !showDate;
    [self addSlots:nil];
}

- (NSMutableAttributedString *)buildDateString:(NSDate *)date {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"2016.8\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:@"08日" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
    [string appendAttributedString:string1];
    return string;
}

- (void)addSlots:(HHCoachSchedule *)schedule {
    
    for (int i = 0; i < 4; i++) {
        UIImageView *avatarView = [[UIImageView alloc] init];
        avatarView.layer.cornerRadius = kAvatarRadius;
        avatarView.layer.masksToBounds = YES;
        avatarView.backgroundColor = [UIColor blueColor];
        //avatarView.image = [UIImage imageNamed:@"ic_aboutmsg_logo"];
        [self.rightView addSubview:avatarView];
        
        [avatarView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coachNameLabel.left).offset((i%4) * (10.0f + kAvatarRadius * 2.0f));
            make.top.equalTo(self.otherInfoLabel.bottom).offset(10.0f + (i/4) * (15.0f + kAvatarRadius * 2.0f));
            make.width.mas_equalTo(kAvatarRadius * 2.0f);
            make.height.mas_equalTo(kAvatarRadius * 2.0f);
        }];
    }
    
}

- (void)bookSchedule {
    if (self.bookBlock) {
        self.bookBlock(self.schedule);
    }
}

@end
