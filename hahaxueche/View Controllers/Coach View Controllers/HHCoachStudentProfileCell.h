//
//  HHCoachStudentProfileCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/7/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHReceiptTableViewCell.h"
#import "HHStudent.h"
#import "HHCoachListViewController.h"



@interface HHCoachStudentProfileCell : HHReceiptTableViewCell

@property (nonatomic, strong) UIButton *phoneNumberButton;
@property (nonatomic, strong) HHStudent *student;

@property (nonatomic, strong) HHGenericCompletion callStudentBlock;

@end
