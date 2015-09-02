//
//  HHAlipayOrder.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/30/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHAlipayOrder.h"

@implementation HHAlipayOrder

- (instancetype)initWithOrderNumber:(NSString *)orderNumber amount:(NSNumber *)amount {
    self = [super init];
    if (self) {
        self.partner = @"2088021205742841";
        self.seller = @"xiaosong@xiaosong.ren";
        
        self.tradeNO = orderNumber;
        self.productName = NSLocalizedString(@"哈哈学车-学车费用", nil);
        self.productDescription = NSLocalizedString(@"哈哈学车-学车费用", nil);
        
#if DEBUG
        self.amount = [NSString stringWithFormat:@"%.2f", 0.01];
#else
        
        self.amount = [NSString stringWithFormat:@"%.2f", [amount floatValue]];
#endif
        
        self.productDescription = nil;
        self.notifyURL = nil;
        
        self.service = @"mobile.securitypay.pay";
        self.paymentType = @"1";
        self.inputCharset = @"utf-8";
        self.itBPay = @"30m";
        self.showUrl = @"m.alipay.com";
    }
    return self;
}

- (NSString *)description {
    NSMutableString * discription = [NSMutableString string];
    if (self.partner) {
        [discription appendFormat:@"partner=\"%@\"", self.partner];
    }
    
    if (self.seller) {
        [discription appendFormat:@"&seller_id=\"%@\"", self.seller];
    }
    if (self.tradeNO) {
        [discription appendFormat:@"&out_trade_no=\"%@\"", self.tradeNO];
    }
    if (self.productName) {
        [discription appendFormat:@"&subject=\"%@\"", self.productName];
    }
    
    if (self.productDescription) {
        [discription appendFormat:@"&body=\"%@\"", self.productDescription];
    }
    if (self.amount) {
        [discription appendFormat:@"&total_fee=\"%@\"", self.amount];
    }
    if (self.notifyURL) {
        [discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL];
    }
    
    if (self.service) {
        [discription appendFormat:@"&service=\"%@\"",self.service];//mobile.securitypay.pay
    }
    if (self.paymentType) {
        [discription appendFormat:@"&payment_type=\"%@\"",self.paymentType];//1
    }
    
    if (self.inputCharset) {
        [discription appendFormat:@"&_input_charset=\"%@\"",self.inputCharset];//utf-8
    }
    if (self.itBPay) {
        [discription appendFormat:@"&it_b_pay=\"%@\"",self.itBPay];//30m
    }
    if (self.showUrl) {
        [discription appendFormat:@"&show_url=\"%@\"",self.showUrl];//m.alipay.com
    }
    if (self.rsaDate) {
        [discription appendFormat:@"&sign_date=\"%@\"",self.rsaDate];
    }
    if (self.appID) {
        [discription appendFormat:@"&app_id=\"%@\"",self.appID];
    }
    for (NSString * key in [self.extraParams allKeys]) {
        [discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
    }
    return discription;
}

@end
