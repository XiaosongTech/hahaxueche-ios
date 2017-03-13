//
//  HHInsuranceReceiptViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 01/03/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ReceiptType) {
    ReceiptTypeInsurance, // 赔付宝
    ReceiptTypePrepay, //预付定金
};

@interface HHGenericReceiptViewController : UIViewController

- (instancetype)initWithType:(ReceiptType)type;

@end
