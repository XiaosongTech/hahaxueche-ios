//
//  HHAdvisorView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/30/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHAdvisorViewBlock)();

@interface HHAdvisorView : UIView

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *botView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *verticalLine;

@property (nonatomic, strong) UIButton *callButton;

@property (nonatomic, strong) HHAdvisorViewBlock callBlock;

@end
