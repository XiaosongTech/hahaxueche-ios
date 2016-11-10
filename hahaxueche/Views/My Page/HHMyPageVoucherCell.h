//
//  HHMyPageVoucheCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 10/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHMyPageItemTitleView.h"
#import "HHMyPageItemView.h"

@interface HHMyPageVoucherCell : UITableViewCell

@property (nonatomic, strong) HHMyPageItemTitleView *titleView;
@property (nonatomic, strong) HHMyPageItemView *supportOnlineView;
@property (nonatomic, strong) HHMyPageItemView *myAdvisorView;

@end
