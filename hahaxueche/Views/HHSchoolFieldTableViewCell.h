//
//  HHSchoolFieldTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 07/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHDrivingSchool.h"
#import "HHField.h"

typedef void (^HHFieldBlock)(HHField *field);

@interface HHSchoolFieldTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) HHFieldBlock fieldBlock;
@property (nonatomic, strong) HHFieldBlock checkFieldBlock;
@property (nonatomic, strong) HHDrivingSchool *school;

- (void)setupCellWithSchool:(HHDrivingSchool *)school;

@end
