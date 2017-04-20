//
//  HHCoachTagView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/5/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHDrivingSchool.h"

typedef void (^HHDrivingSchoolCompletion)(HHDrivingSchool *school);

@interface HHCoachTagView : UIView

@property (nonatomic, strong) UIView *dot;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) HHDrivingSchool *school;
@property (nonatomic, strong) HHDrivingSchoolCompletion tapAction;


- (void)setupWithDrivingSchool:(HHDrivingSchool *)school;

@end
