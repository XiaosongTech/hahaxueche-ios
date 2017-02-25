//
//  HHUploadIDViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 23/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UploadViewType) {
    UploadViewTypeContract, // 签署合同
    UploadViewTypePeifubao //赔付宝
    
};

@interface HHUploadIDViewController : UIViewController

- (instancetype)initWithType:(UploadViewType)type;

@end
