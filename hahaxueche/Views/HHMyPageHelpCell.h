//
//  HHMyPageHelpCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHMyPageItemTitleView.h"
#import "HHMyPageItemView.h"

@interface HHMyPageHelpCell : UITableViewCell

@property (nonatomic, strong) HHMyPageItemTitleView *titleView;
@property (nonatomic, strong) HHMyPageItemView *FAQView;
@property (nonatomic, strong) HHMyPageItemView *aboutView;

@end
