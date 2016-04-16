//
//  HHNotificationCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHNotification.h"

@interface HHNotificationCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avaView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UIView *botLine;

- (void)setupCellWithNotification:(HHNotification *)notification;
@end
