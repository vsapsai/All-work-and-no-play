//
//  AXValueWrapperTest.m
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/14/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "AXValueWrapper.h"

@interface AXValueWrapperTest : SenTestCase
@end

@implementation AXValueWrapperTest

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
	STAssertEqualObjects(rangeWrapper.value, expectedRangeValue, nil);
}

- (void)testRangeNSValue
{
	NSValue *rangeValue = [NSValue valueWithRange:NSMakeRange(0, 7)];
	AXValueWrapper *rangeWrapper = [AXValueWrapper wrapperWithNSValue:rangeValue];
	AXValueWrapper *otherRangeWrapper = [AXValueWrapper wrapperWithAXValueRef:rangeWrapper.AXValue];
	STAssertEqualObjects(otherRangeWrapper.value, rangeValue, nil);
}

#pragma mark -

- (void)testRectAXValue
{
	CGRect rect = CGRectMake(7.0, 8.0, 12.0, 42.0);
	AXValueRef rectValueRef = AXValueCreate(kAXValueCGRectType, &rect);
	AXValueWrapper *rectWrapper = [AXValueWrapper wrapperWithAXValueRef:rectValueRef];
	CFRelease(rectValueRef);
	NSValue *expectedRectValue = [NSValue valueWithRect:NSMakeRect(7.0, 8.0, 12.0, 42.0)];
	STAssertEqualObjects(rectWrapper.value, expectedRectValue, nil);
}

- (void)testRectNSValue
{
	NSValue *rectValue = [NSValue valueWithRect:NSMakeRect(7.0, 8.0, 12.0, 42.0)];
	AXValueWrapper *rectWrapper = [AXValueWrapper wrapperWithNSValue:rectValue];
	AXValueWrapper *otherRectWrapper = [AXValueWrapper wrapperWithAXValueRef:rectWrapper.AXValue];
	STAssertEqualObjects(otherRectWrapper.value, rectValue, nil);
}

#pragma mark -

- (void)testPointAXValue
{
	CGPoint point = CGPointMake(4.0, 2.0);
	AXValueRef pointValueRef = AXValueCreate(kAXValueCGPointType, &point);
	AXValueWrapper *pointWrapper = [AXValueWrapper wrapperWithAXValueRef:pointValueRef];
	CFRelease(pointValueRef);
	NSValue *expectedPointValue = [NSValue valueWithPoint:NSMakePoint(4.0, 2.0)];
	STAssertEqualObjects(pointWrapper.value, expectedPointValue, nil);
}

- (void)testPointNSValue
{
	NSValue *pointValue = [NSValue valueWithPoint:NSMakePoint(4.0, 2.0)];
	AXValueWrapper *pointWrapper = [AXValueWrapper wrapperWithNSValue:pointValue];
	AXValueWrapper *otherPointWrapper = [AXValueWrapper wrapperWithAXValueRef:pointWrapper.AXValue];
	STAssertEqualObjects(otherPointWrapper.value, pointValue, nil);
}

#pragma mark -

- (void)testSizeAXValue
{
	CGSize size = CGSizeMake(33.0, 81.0);
	AXValueRef sizeValueRef = AXValueCreate(kAXValueCGSizeType, &size);
	AXValueWrapper *sizeWrapper = [AXValueWrapper wrapperWithAXValueRef:sizeValueRef];
	CFRelease(sizeValueRef);
	NSValue *expectedSizeValue = [NSValue valueWithSize:NSMakeSize(33.0, 81.0)];
	STAssertEqualObjects(sizeWrapper.value, expectedSizeValue, nil);
}

- (void)testSizeNSValue
{
	NSValue *sizeValue = [NSValue valueWithSize:NSMakeSize(33.0, 81.0)];
	AXValueWrapper *sizeWrapper = [AXValueWrapper wrapperWithNSValue:sizeValue];
	AXValueWrapper *otherSizeWrapper = [AXValueWrapper wrapperWithAXValueRef:sizeWrapper.AXValue];
	STAssertEqualObjects(otherSizeWrapper.value, sizeValue, nil);
}

@end
