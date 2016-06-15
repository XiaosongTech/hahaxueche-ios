//
//  HHCoachServiceTypeCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 6/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"

@interface HHCoachServiceTypeCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIView *mainView;

- (void)setupCellWithCoach:(HHCoach *)coach;

@end
