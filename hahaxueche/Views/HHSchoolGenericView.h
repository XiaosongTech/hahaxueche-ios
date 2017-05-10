//
//  HHSchoolGenericView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 04/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHSchoolGenericView : UIView

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

- (void)setupViewWithLeftText:(NSString *)leftText rightText:(NSString *)rightText;

@end
