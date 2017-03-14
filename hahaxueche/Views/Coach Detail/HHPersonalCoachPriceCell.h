//
//  HHCoachPriceCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 6/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPersonalCoach.h"
#import "HHPriceSectionView.h"

typedef void (^HHLicenseTypeBlock)(NSInteger licenseType);

@interface HHPersonalCoachPriceCell : UITableViewCell

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) HHPriceSectionView *c1View;
@property (nonatomic, strong) HHPriceSectionView *c2View;

@property (nonatomic, strong) HHLicenseTypeBlock licenseTypeAction;

- (void)setupCellWithPersonalCoach:(HHPersonalCoach *)coach;


@end
