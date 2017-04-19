//
//  HHCalloutView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 18/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHGradientButton.h"
#import "HHField.h"

typedef void (^HHSendAddressCompletion)(HHField *field);

@interface HHCalloutView : UIView

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) HHGradientButton *sendButton;
@property (nonatomic, strong) HHSendAddressCompletion sendAction;
@property (nonatomic, strong) HHField *field;

- (instancetype)initWithField:(HHField *)field;

@end
