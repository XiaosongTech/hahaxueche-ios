//
//  HHNotificationExplanationView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHOkButtonView.h"

typedef void (^HHNotificationExpBlock)();

@interface HHNotificationExplanationView : UIView

@property (nonatomic, strong) HHOkButtonView *okButtonView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *expLabel;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) HHNotificationExpBlock okBlock;

@end
