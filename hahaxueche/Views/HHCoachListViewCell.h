//
//  HHCoachListViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHCoachListViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *goldenCoachIcon;
@property (nonatomic, strong) UILabel *trainingYearLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *marketPriceLabel;
@property (nonatomic, strong) UIView *bottomLine;


@end
