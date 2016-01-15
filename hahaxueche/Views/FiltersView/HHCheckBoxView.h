//
//  HHCheckBoxView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"

@interface HHCheckBoxView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) BEMCheckBox *checkBox;
@property (nonatomic, strong) UIView *containerView;

- (instancetype)initWithTilte:(NSString *)title isChecked:(BOOL)isChecked;

@end
