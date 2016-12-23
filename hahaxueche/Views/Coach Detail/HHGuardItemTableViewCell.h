//
//  HHGuardItemTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 23/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHGuardItemTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *verifiedLabel;
@property (nonatomic, strong) UIView *botLine;

- (void)setupWithIcon:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle verifiedText:(NSString *)verifiedText;

@end
