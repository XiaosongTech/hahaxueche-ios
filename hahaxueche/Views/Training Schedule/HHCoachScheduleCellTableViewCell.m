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
#import "HHStudentStore.h"
#import "HHFormatUtility.h"
#import "HHStudent.h"

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
        [self.botButton addTarget:self action:@selector(botTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.rightView addSubview:self.botButton];
        
        self.coachNameLabel = [[UILabel alloc] init];
        self.coachNameLabel.textColor = [UIColor HHTextDarkGray];
        self.coachNameLabel.font = [UIFont systemFontOfSize:20.0f];
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
        make.top.equalTo(self.coachNameLabel.bottom).offset(8.0f);
    }];
    
}

- (void)setupCellWithSchedule:(HHCoachSchedule *)schedule showLine:(BOOL)showLine showDate:(BOOL)showDate {
    self.schedule = schedule;
    self.dateLabel.attributedText = [self buildDateString:schedule.startTime];
    self.coachNameLabel.text = schedule.coach.name;
    self.timeLabel.text = [self buildTimeString:schedule];;
    self.otherInfoLabel.text = [self buildInfoString:schedule];
    self.botLine.hidden = !showLine;
    self.dateLabel.hidden = !showDate;
    self.stickView.hidden = !showDate;
    
    switch ([schedule.status integerValue]) {
            
        case 1: {
            [self.botButton setTitle:@"取消课程" forState:UIControlStateNormal];
            self.botButton.backgroundColor = [UIColor HHCancelRed];
        } break;
            
        case 2: {
            [self.botButton setTitle:@"课程评分" forState:UIControlStateNormal];
            self.botButton.backgroundColor = [UIColor HHConfirmGreen];
        }
        case 3: {
            [self.botButton setTitle:@"已完成" forState:UIControlStateNormal];
            self.botButton.backgroundColor = [UIColor HHLightestTextGray];
        } break;
            
        default: {
            [self.botButton setTitle:@"预约课程" forState:UIControlStateNormal];
            self.botButton.backgroundColor = [UIColor HHOrange];
        }
            break;
    }
    [self addSlots:schedule];
}

- (NSString *)buildInfoString:(HHCoachSchedule *)schedule {
    return [NSString stringWithFormat:@"%@, %@, %@人/%@人", [schedule getCourseName], [schedule getPhaseName], [schedule.registeredStudentCount stringValue], [schedule.maxStudentCount stringValue]];
}

- (NSString *)buildTimeString:(HHCoachSchedule *)schedule {
    return [NSString stringWithFormat:@"(%@ - %@)", [[HHFormatUtility timeFormatter] stringFromDate:schedule.startTime], [[HHFormatUtility timeFormatter] stringFromDate:schedule.endTime]];
}

- (NSMutableAttributedString *)buildDateString:(NSDate *)date {
    NSArray *stringParts = [[[HHFormatUtility onlyDateFormatter] stringFromDate:date] componentsSeparatedByString:@"-"];
    NSString *yearMonth = [NSString stringWithFormat:@"%@.%@\n", stringParts[0], stringParts[1]];
    NSString *dateString = [NSString stringWithFormat:@"%@日", stringParts[2]];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:yearMonth attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:dateString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
    [string appendAttributedString:string1];
    return string;
}

- (void)addSlots:(HHCoachSchedule *)schedule {
    for (UIImageView *imageView in self.avaArray) {
        [imageView removeFromSuperview];
    }
    
    self.avaArray = [NSMutableArray array];
    
    for (int i = 0; i < schedule.maxStudentCount.integerValue; i++) {
        UIImageView *avatarView = [[UIImageView alloc] init];
        avatarView.layer.cornerRadius = kAvatarRadius;
        avatarView.layer.masksToBounds = YES;
        avatarView.tag = i;
        avatarView.userInteractionEnabled = YES;
        if ([schedule.status integerValue] == 0) {
            avatarView.image = [UIImage imageNamed:@"ic_class_emptyava"];
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bookSchedule:)];
            [avatarView addGestureRecognizer:tapRecognizer];
        }
        
        [self.rightView addSubview:avatarView];
        [self.avaArray addObject:avatarView];
        
        
        [avatarView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coachNameLabel.left).offset((i%4) * (10.0f + kAvatarRadius * 2.0f));
            make.top.equalTo(self.otherInfoLabel.bottom).offset(15.0f + (i/4) * (15.0f + kAvatarRadius * 2.0f));
            make.width.mas_equalTo(kAvatarRadius * 2.0f);
            make.height.mas_equalTo(kAvatarRadius * 2.0f);
        }];
    }
    
    for (int i = 0; i < schedule.registeredStudents.count; i++) {
        UIImageView *avaView = self.avaArray[i];
        HHStudent *student = schedule.registeredStudents[i];
        [avaView sd_setImageWithURL:[NSURL URLWithString:student.avatarURL] placeholderImage:[UIImage imageNamed:@"ic_mypage_ava"]];
    }
    
}

- (void)botTapped {
    if (self.bookBlock) {
        self.bookBlock(self.schedule);
    }
}

- (void)bookSchedule:(UITapGestureRecognizer *)recognizer {
    UIImageView *emptyAvaView = (UIImageView *)recognizer.view;
    if (emptyAvaView.tag + 1 > ([self.schedule.registeredStudents count])) {
        if (self.bookBlock) {
            self.bookBlock(self.schedule);
        }
    }
}

@end
