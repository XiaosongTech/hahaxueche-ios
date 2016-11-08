//
//  HHClubItemView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/20/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHClubItemBlock)();

@interface HHClubItemView : UIView

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title subTitle:(NSString *)subTitle showRightLine:(BOOL)showRightLine showBotLine:(BOOL)showBotLine;

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) HHClubItemBlock actionBlock;

@end
