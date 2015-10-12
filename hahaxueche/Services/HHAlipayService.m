//
//  HHAlipayService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/30/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHAlipayService.h"
#import "DataSigner.h"


@interface HHAlipayService ()

@property (nonatomic, strong) NSString *privateKey;

@end

@implementation HHAlipayService

+ (HHAlipayService *)sharedInstance {
    static HHAlipayService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHAlipayService alloc] init];
        sharedInstance.privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALM+x+lugLP1iWpn7L5sSforQ8GvXUpPRgNF0IM7PMcNQ0g8i2RjWND0lrAkH+YKoYCTHRkF7c3iVnPvvGy0/QvW/7TYYd/WUg5yA81kCQ8I9qhUwIbQCpRW5c2yieKq0tCfVK8Wnx51AZln2/znaliu1qXq9YVzzErpK7VfKECFAgMBAAECgYEAoFiiN4Vd5x7YrfKIC5UN3JjFhUeeOfKOnDDhJfRhG2QW81EOFWD2O/8BqlK2onCSJ1XzasYuBMbcNdyZf9msn2BiV2xBqRn2+IstmaQgPRw8Lx4PXnK4369b61i3pJUByUx21GOlz07DzQj6TKCeleDxhurekcciC4t+tln3/4ECQQDuaLzPutVdyDe7796cxx8PQd1YBon8fp6UPfwo5prMhzxbDDDhQbgukFFkJl5rkUQEMRmqI+XDL4WymoAsn7JlAkEAwHiCJpgFy75Tx0b4X3kXO7yKxWZTbtEcpNIDnqDIIBSlacmI+o8imWldlQB6K+zk5e4ZbpiVpwPw8BSjcAxjoQJAFJftf1AXMCOkVNKSex5kG3BIC1t9Pdc+IXX9Oxc4VeR0nTS/YCXKIBONREZgL5B7vJT1L5IsPaD0PopD+hbNVQJAMrsQww9q56sA9hOUv8VxBEPL5//ymdDwVdktLxB970bB2sJOIoy7t+f3zKBVk2Jbaud5OJdrSpxVU1J9SblaQQJAYoavt7OMaQzrk/9sfacxZzHJtUDVemWSy02ntbehkQVhZuctYe32dVM4oq0YWUgbgVDdhhQSFK9QnyWiAHR5KA==";
    });
    
    return sharedInstance;
}

- (void)payByAlipayWith:(HHAlipayOrder *)order completion:(HHAliPayServiceGenericCompletionBlock)completion {
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"hhxc";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(self.privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if(completion) {
                completion(resultDic);
            }
        }];
        
    }
}

@end
