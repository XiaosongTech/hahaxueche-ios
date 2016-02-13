//
//  HHCoachDetailSectionOneCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoachDetailSingleInfoView.h"
#import "HHCoach.h"

@interface HHCoachDetailSectionOneCell : UITableViewCell

@property (nonatomic, strong) HHCoachDetailSingleInfoView *priceCell;
@property (nonatomic, strong) HHCoachDetailSingleInfoView *courseTypeCell;
@property (nonatomic, strong) HHCoachDetailSingleInfoView *fieldAddressCell;

@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UIView *horizontalLine;


- (void)setupWithCoach:(HHCoach *)coach;

@end
