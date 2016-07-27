//
//  HHHomePageSupportView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/20/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHHomePageSupportViewBlock)();

@interface HHHomePageSupportView : UIView

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title showRightLine:(BOOL)showRightLine;

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIView *rightLine;
@property(nonatomic, strong) UIView *bottomLine;

@property(nonatomic, strong) HHHomePageSupportViewBlock actionBlock;

@end
