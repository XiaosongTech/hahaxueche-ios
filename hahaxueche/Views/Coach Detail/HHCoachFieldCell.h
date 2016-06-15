//
//  HHCoachFieldCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 6/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHField.h"

typedef void (^HHFieldBlock)();

@interface HHCoachFieldCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *fieldLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) HHFieldBlock fieldBlock;

- (void)setupCellWithField:(HHField *)field;

@end
