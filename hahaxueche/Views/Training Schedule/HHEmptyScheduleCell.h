//
//  HHEmptyScheduleCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/17/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHEmptyScheduleCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;

- (void)setupCellWithTitle:(NSString *)title;


@end
