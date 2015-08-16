//
//  HHTimeSlotSectionTitleView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/9/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHTimeSlotSectionTitleView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

- (instancetype)initWithTitle:(NSString *)title;

@end
