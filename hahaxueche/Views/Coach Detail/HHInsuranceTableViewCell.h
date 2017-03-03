//
//  HHInsuranceTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 24/02/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHCoachInsuranceBlock)();

@interface HHInsuranceTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIButton *questionButton;
@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) HHCoachInsuranceBlock questionAction;

@end
