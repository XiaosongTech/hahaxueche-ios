//
//  HHMyPageItemTitleView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHMyPageItemTitleView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *botLine;

- (instancetype)initWithTitle:(NSString *)title;

@end
