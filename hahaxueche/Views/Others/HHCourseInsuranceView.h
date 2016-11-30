//
//  HHCourseInsuranceView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 30/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHScoreSlotView.h"

@interface HHCourseInsuranceView : UIView

- (instancetype)initWithImage:(UIImage *)image count:(NSNumber *)count text:(NSString *)text buttonTitle:(NSString *)buttonTitle showSlotView:(BOOL)showSlotView peopleCount:(NSNumber *)peopleCount;

@property (nonatomic, strong) UIImageView *cardView;
@property (nonatomic, strong) HHScoreSlotView *slotView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *countLabel;


@end
