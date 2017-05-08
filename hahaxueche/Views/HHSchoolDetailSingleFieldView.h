//
//  HHSchoolDetailSingleFieldView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 07/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHField.h"
#import "HHSchoolFieldTableViewCell.h"
#import "HHGradientButton.h"


@interface HHSchoolDetailSingleFieldView : UIView

- (instancetype)initWithField:(HHField *)field;

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) HHGradientButton *checkFieldButton;
@property (nonatomic, strong) HHFieldBlock checkFieldBlock;

@property (nonatomic, strong) HHField *field;

@end
