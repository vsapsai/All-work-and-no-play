//
//  WPPatternApplicatorTest.m
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/21/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "WPPatternApplicator.h"

@interface WPPatternApplicatorTest : SenTestCase
@end

@interface WPPatternApplicator(VisibleToUnitTest)
- (NSString *)componentsJoinedInCamelCaseStyle:(NSArray *)components;
@end

@implementation WPPatternApplicatorTest

- (void)testJoinInCamelCaseStyle
{
	WPPatternApplicator *patternApplicator = [[[WPPatternApplicator alloc] init] autorelease];
	NSString *actualResult = [patternApplicator componentsJoinedInCamelCaseStyle:nil];
	STAssertEqualObjects(actualResult, @"", nil);
	actualResult = [patternApplicator componentsJoinedInCamelCaseStyle:[NSArray array]];
	STAssertEqualObjects(actualResult, @"", nil);

	actualResult = [patternApplicator componentsJoinedInCamelCaseStyle:[NSArray arrayWithObjects:@"foo", nil]];
	STAssertEqualObjects(actualResult, @"foo", nil);
	actualResult = [patternApplicator componentsJoinedInCamelCaseStyle:[NSArray arrayWithObjects:@"foo", @"bar", nil]];
	STAssertEqualObjects(actualResult, @"fooBar", nil);
}

- (void)testSimplePatternApplication
{
	NSAttributedString *originalString = [[[NSAttributedString alloc] initWithString:@"blahbl(bla); {}"] autorelease];
	WPPatternApplicator *patternApplicator = [[[WPPatternApplicator alloc] initWithPattern:@"foo bar" attributedString:originalString] autorelease];
	NSString *actualString = [[patternApplicator attributedStringByApplyingPattern] string];
	STAssertEqualObjects(actualString, @"fooBar(foo); {}", nil);
}

@end
