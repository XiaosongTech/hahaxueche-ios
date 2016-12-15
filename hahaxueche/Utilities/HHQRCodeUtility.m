//
//  HHQRCodeUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 14/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHQRCodeUtility.h"
#import <CoreImage/CoreImage.h>

@implementation HHQRCodeUtility

+ (HHQRCodeUtility *)sharedManager {
    static HHQRCodeUtility *manager = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        manager = [[HHQRCodeUtility alloc] init];
    });
    
    return manager;
}

- (UIImage *)generateQRCodeWithString:(NSString *)string {
    NSData *stringData = [string dataUsingEncoding: NSISOLatin1StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    return [UIImage imageWithCIImage:[qrFilter.outputImage imageByApplyingTransform:CGAffineTransformMakeScale(5.0f, 5.0f)]] ;
}


@end
