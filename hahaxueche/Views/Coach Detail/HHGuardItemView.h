//
//  HHGuardItemView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 03/01/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHGuardItemView : UIView

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *label;

- (instancetype)initWithImg:(UIImage *)img title:(NSString *)title;

@end
