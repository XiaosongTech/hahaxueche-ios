//
//  HHReceiptViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"

typedef NS_ENUM(NSInteger, ReceiptViewType) {
    ReceiptViewTypeContract, // 签署合同
    ReceiptViewTypePeifubao //赔付宝
    
};

@interface HHReceiptViewController : UIViewController

- (instancetype)initWithCoach:(HHCoach *)coach type:(ReceiptViewType)type;


@end
