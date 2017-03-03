//
//  HHInsuranceSelectionView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 24/02/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^HHInsuranceBlock)(BOOL confirmed, BOOL checked);
@interface HHInsuranceSelectionView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic) BOOL checked;
@property (nonatomic, strong) HHInsuranceBlock buttonAction;


- (instancetype)initWithFrame:(CGRect)frame selected:(BOOL)selected;

@end
