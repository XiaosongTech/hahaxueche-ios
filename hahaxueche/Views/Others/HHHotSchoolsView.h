//
//  HHHotSchoolsView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 09/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHDrivingSchool.h"

typedef void (^HHHotSchoolCompletion)(HHDrivingSchool *school);

@interface HHHotSchoolsView : UIView

@property (nonatomic, strong) UIView *titleContainerView;
@property (nonatomic, strong) UIView *botContainerView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *hotView;;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *botLine;

@property (nonatomic, strong) HHHotSchoolCompletion schoolBlock;


@end
