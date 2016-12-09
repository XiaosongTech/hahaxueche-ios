//
//  HHPlatformGuardTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 09/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"

typedef void (^HHGuardBlock)();

@interface HHPlatformGuardTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UIView *botLeftView;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) HHGuardBlock actionBlock;

- (void)setupCellWithCoach:(HHCoach *)coach;

@end
