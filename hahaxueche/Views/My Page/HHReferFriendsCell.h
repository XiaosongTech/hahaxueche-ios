//
//  HHReferFriendsCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/27/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHReferral.h"

@interface HHReferFriendsCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avaView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *moneyLabel;

- (void)setupCellWithReferral:(HHReferral *)referral;

@end
