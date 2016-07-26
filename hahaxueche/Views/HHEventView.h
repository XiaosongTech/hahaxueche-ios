//
//  HHActivityView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/25/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHEvent.h"
#import "HHCountDownView.h"

typedef void (^HHEventViewBlock)(HHEvent *event);

@interface HHEventView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) HHCountDownView *countDownView;
@property (nonatomic, strong) UIView *botLine;

@property (nonatomic, strong) HHEvent *event;
@property (nonatomic) BOOL fullLine;
@property (nonatomic, strong) HHEventViewBlock eventBlock;

- (instancetype)initWithEvent:(HHEvent *)event fullLine:(BOOL)fullLine;

@end
