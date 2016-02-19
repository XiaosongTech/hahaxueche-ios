//
//  HHMyCoachBasicInfoCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHMyPageItemTitleView.h"
#import "HHMyPageItemView.h"
#import "HHCoach.h"

@interface HHMyCoachBasicInfoCell : UITableViewCell

@property (nonatomic, strong) HHMyPageItemTitleView *titleView;
@property (nonatomic, strong) HHMyPageItemView *phoneNumberView;
@property (nonatomic, strong) HHMyPageItemView *addressView;

- (void)setupCellWithCoach:(HHCoach *)coach;

@end
