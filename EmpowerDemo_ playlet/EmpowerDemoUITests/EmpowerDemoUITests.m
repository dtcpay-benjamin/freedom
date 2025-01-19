//
//  EmpowerDemoUITests.m
//  EmpowerDemoUITests
//
//  Created by yuxr on 2022/1/20.
//  Copyright © 2022 bytedance. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface EmpowerDemoUITests : XCTestCase

@end

@implementation EmpowerDemoUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // UI tests must launch the application that they test.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    XCTestExpectation *expectNotCrash = [self expectationWithDescription:@"expectNotCrash"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectNotCrash fulfill];
    });
    [self waitForExpectations:@[expectNotCrash] timeout:25];
}

@end
