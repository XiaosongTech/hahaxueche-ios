//
//  HHMyCoachCourseInfoCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHMyPageItemTitleView.h"
#import "HHMyPageItemView.h"
#import "HHStudent.h"

@interface HHMyCoachCourseInfoCell : UITableViewCell

@property (nonatomic, strong) HHMyPageItemTitleView *titleView;
@property (nonatomic, strong) HHMyPageItemView *classTypeView;
@property (nonatomic, strong) HHMyPageItemView *feeDetailView;

- (void)setupCellWithStudent:(HHStudent *)student;

@end
