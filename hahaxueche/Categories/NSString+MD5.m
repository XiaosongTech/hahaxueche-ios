//
//  NSString+MD5.m
//  hahaxueche
//
//  Created by Zixiao Wang on 10/28/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+MD5.h"

@implementation NSString (MD5)

- (NSString *)MD5String {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
