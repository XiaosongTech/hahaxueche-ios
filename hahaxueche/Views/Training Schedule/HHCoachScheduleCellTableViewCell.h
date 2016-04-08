//
//  HHCoachScheduleCellTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/8/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHCoachScheduleCellTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIImageView *stickView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *coachNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *otherInfo;
@property (nonatomic, strong) UIButton *botButton;

@property (nonatomic, strong) UIView *botLine;

@end
