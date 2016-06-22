//
//  HHStudentServiceTests.m
//  hahaxueche
//
//  Created by Zixiao Wang on 6/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HHStudentService.h"

@interface HHStudentServiceTests : XCTestCase

@property (nonatomic, strong) HHStudent *student;

@end

@implementation HHStudentServiceTests

- (void)setUp {
    [super setUp];
    [HHStudentService sharedInstance];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
