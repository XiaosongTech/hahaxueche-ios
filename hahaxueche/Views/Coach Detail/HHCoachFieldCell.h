//
//  HHCoachFieldCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 6/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHField.h"

typedef void (^HHCoachFieldBlock)(HHField *feild);

@interface HHCoachFieldCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *fieldLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIButton *sendAddressButton;
@property (nonatomic, strong) HHCoachFieldBlock fieldBlock;
@property (nonatomic, strong) HHCoachFieldBlock sendAddressBlock;

@property (nonatomic, strong) HHField *field;

- (void)setupCellWithField:(HHField *)field;

@end
