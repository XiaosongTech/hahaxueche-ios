//
//  HHEventCardCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/27/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCountDownView.h"
#import "HHEvent.h"

@interface HHEventCardCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) HHCountDownView *countDownView;
@property (nonatomic, strong) UILabel *moreLabel;

- (void)setupCellWithEvent:(HHEvent *)event;

@end
