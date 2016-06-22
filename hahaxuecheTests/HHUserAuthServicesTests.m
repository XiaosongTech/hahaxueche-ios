//
//  HHUserAuthServicesTests.m
//  hahaxueche
//
//  Created by Zixiao Wang on 6/22/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HHUserAuthService.h"

@interface HHUserAuthServicesTests : XCTestCase

@property (nonatomic, strong) HHStudent *student;

@end

@implementation HHUserAuthServicesTests

- (void)setUp {
    [super setUp];
    [HHUserAuthService sharedInstance];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUserLoginWithPassword {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing get test account works"];
    [[HHUserAuthService sharedInstance] loginWithCellphone:@"18506830113" password:@"111111" completion:^(HHStudent *student, NSError *error) {
        if (!error) {
            if (student) {
                self.student = student;
                [expectation fulfill];
            } else {
                XCTFail(@"Return data incorrect");
            }
        } else {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];

}

- (void)testIsTokenValid {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing token valid works"];
    [[HHUserAuthService sharedInstance] isTokenValid:@"18506830113" completion:^(BOOL valid) {
        if (valid) {
            [expectation fulfill];
        } else {
            XCTFail(@"Token invalid");
        }
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];

}

- (void)testLogout {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing logout works"];
    [[HHUserAuthService sharedInstance] logOutWithCompletion:^(NSError *error) {
        if (!error) {
            [expectation fulfill];
        } else {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];

}


@end
