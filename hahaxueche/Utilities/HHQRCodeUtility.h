//
//  HHQRCodeUtility.h
//  hahaxueche
//
//  Created by Zixiao Wang on 14/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHQRCodeUtility : NSObject

+ (HHQRCodeUtility *)sharedManager;
- (UIImage *)generateQRCodeWithString:(NSString *)string;

@end
