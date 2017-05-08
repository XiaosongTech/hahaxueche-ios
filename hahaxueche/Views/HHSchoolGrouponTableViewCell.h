//
//  HHSchoolGrouponTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 07/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHDrivingSchool.h"

@interface HHSchoolGrouponTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

- (void)setupCellWithSchool:(HHDrivingSchool *)school;

@end
