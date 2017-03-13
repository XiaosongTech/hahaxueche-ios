//
//  HHCoachPriceView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 08/03/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@interface HHCoachPriceView : UIView

@property (nonatomic, strong) UIView *licenseTypeView;
@property (nonatomic, strong) HHCoach *coach;
@property (nonatomic, strong) UIView *c1View;
@property (nonatomic, strong) UIView *c2View;

- (instancetype)initWithCoach:(HHCoach *)coach;

@end
