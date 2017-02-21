//
//  HHReferreeCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/19/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHReferral.h"

@interface HHReferreeCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *botLine;

- (void)setupCellWithReferral:(HHReferral *)referral;

@end
