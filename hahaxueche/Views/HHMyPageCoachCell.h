//
//  HHMyPageCoachCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHMyPageItemTitleView.h"
#import "HHMyPageItemView.h"
#import "HHCoach.h"

static CGFloat const kTitleViewHeight = 40.0f;
static CGFloat const kItemViewHeight = 50.0f;
static CGFloat const kTopPadding = 15.0f;

@interface HHMyPageCoachCell : UITableViewCell

@property (nonatomic, strong) HHMyPageItemTitleView *titleView;
@property (nonatomic, strong) HHMyPageItemView *myCoachView;
@property (nonatomic, strong) HHMyPageItemView *followedCoachView;

@end
