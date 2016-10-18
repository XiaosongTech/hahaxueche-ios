//
//  HHPersonalCoachFiltersView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 18/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPersonalCoachFilters.h"

@interface HHPersonalCoachFiltersView : UIView

- (instancetype)initWithFilters:(HHPersonalCoachFilters *)coachFilters frame:(CGRect)frame;

@property (nonatomic, strong) HHPersonalCoachFilters *coachFilters;

@end
