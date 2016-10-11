//
//  HHCoachPriceCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 6/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPriceItemView.h"
#import "HHCoach.h"

@interface HHCoachPriceCell : UITableViewCell

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HHPriceItemView *standartPriceItemView;
@property (nonatomic, strong) HHPriceItemView *VIPPriceItemView;
@property (nonatomic, strong) HHPriceItemView *c2PriceItemView;
@property (nonatomic, strong) HHPriceItemView *c2VIPPriceItemView;

- (void)setupCellWithCoach:(HHCoach *)coach;


@end
