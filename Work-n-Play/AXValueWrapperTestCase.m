//
//  AXValueWrapperTestCase.m
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/14/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "AXValueWrapper.h"

@interface AXValueWrapperTestCase : SenTestCase
@end

@implementation AXValueWrapperTestCase

#pragma mark -

- (void)testNullAXValue
{
	AXValueWrapper *nullWrapper = [AXValueWrapper wrapperWithAXValueRef:NULL];
	STAssertNotNil(nullWrapper, nil);
	STAssertTrue(NULL == nullWrapper.AXValue, nil);
	STAssertNil(nullWrapper.value, nil);
}

- (void)testNilNSValue
{
	AXValueWrapper *nilWrapper = [AXValueWrapper wrapperWithNSValue:nil];
	STAssertNotNil(nilWrapper, nil);
	STAssertTrue(NULL == nilWrapper.AXValue, nil);
	STAssertNil(nilWrapper.value, nil);
}

#pragma mark -

- (void)testRangeAXValue
{
	CFRange range = CFRangeMake(0, 7);
	AXValueRef rangeValueRef = AXValueCreate(kAXValueCFRangeType, &range);
	AXValueWrapper *rangeWrapper = [AXValueWrapper wrapperWithAXValueRef:rangeValueRef];
	CFRelease(rangeValueRef);
	NSValue *expectedRangeValue = [NSValue valueWithRange:NSMakeRange(0, 7)];
	STAssertTrue([rangeWrapper.value isEqualToValue:expectedRangeValue], nil);
}

- (void)testRangeNSValue
{
	NSValue *rangeValue = [NSValue valueWithRange:NSMakeRange(0, 7)];
	AXValueWrapper *rangeWrapper = [AXValueWrapper wrapperWithNSValue:rangeValue];
	AXValueWrapper *otherRangeWrapper = [AXValueWrapper wrapperWithAXValueRef:rangeWrapper.AXValue];
	STAssertTrue([otherRangeWrapper.value isEqualToValue:rangeValue], nil);
}

@end
