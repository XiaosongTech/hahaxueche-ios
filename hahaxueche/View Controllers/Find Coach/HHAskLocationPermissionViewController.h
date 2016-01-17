//
//  HHAskLocationPermissionViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/17/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHButton.h"

@interface HHAskLocationPermissionViewController : UIViewController

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *explanationLabel;
@property (nonatomic, strong) HHButton *button;

@property (nonatomic, strong) UIScrollView *scrollView;

@end
