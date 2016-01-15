//
//  HHFiltersView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoachFilters.h"

typedef void (^HHFiltersViewConfirmCompletion)(HHCoachFilters *filters);
typedef void (^HHFiltersViewCancelCompletion)();

@interface HHFiltersView : UIView

@property (nonatomic, strong) HHCoachFilters *coachFilters;
@property (nonatomic, strong) HHFiltersViewConfirmCompletion confirmBlock;
@property (nonatomic, strong) HHFiltersViewCancelCompletion cancelBlock;

- (instancetype)initWithFilters:(HHCoachFilters *)coachFilters frame:(CGRect)frame;

@end
