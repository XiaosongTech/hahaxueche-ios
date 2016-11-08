//
//  HHOtherFeeItemView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 25/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHOtherFeeItemView : UIView

- (instancetype)initWithTitle:(NSString *)title text:(NSMutableAttributedString *)text;

@property (nonatomic, strong) UIView *stickView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *textLabel;

@end
