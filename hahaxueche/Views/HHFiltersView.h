//
//  HHFiltersView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoachFilters.h"

@interface HHFiltersView : UIView

@property (nonatomic, strong) HHCoachFilters *coachFilters;
- (instancetype)initWithFilters:(HHCoachFilters *)coachFilters frame:(CGRect)frame;

@end
