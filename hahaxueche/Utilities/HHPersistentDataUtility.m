//
//  HHPersistentDataUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 31/03/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHPersistentDataUtility.h"

@implementation HHPersistentDataUtility


+ (HHPersistentDataUtility *)sharedManager {
    static HHPersistentDataUtility *manager = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        manager = [[HHPersistentDataUtility alloc] init];
    });
    
    return manager;
}

- (void)saveDataWithDic:(NSDictionary *)dic key:(NSString *)key {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:key];
    [data writeToFile:filePath atomically:YES];
}

- (NSDictionary *)getDataWithKey:(NSString *)key {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:key];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return dic;
}



@end
