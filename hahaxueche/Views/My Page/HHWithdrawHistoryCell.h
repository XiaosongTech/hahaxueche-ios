//
//  HHWithdrawHistoryCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/27/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHWithdraw.h"

@interface HHWithdrawHistoryCell : UITableViewCell

@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *moneyLabel;

- (void)setupCellWithWithdraw:(HHWithdraw *)withdraw;

@end
