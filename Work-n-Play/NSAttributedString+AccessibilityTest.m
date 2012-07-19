//
//  NSAttributedString+AccessibilityTest.m
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/14/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "NSAttributedString+Accessibility.h"

@interface NSAttributedString_AccessibilityTest : SenTestCase
@end

@implementation NSAttributedString_AccessibilityTest

- (NSAttributedString *)accessibilityAttributedStringFromAttributedString:(NSAttributedString *)attributedString
{
	NSParameterAssert(nil != attributedString);
	NSTextView *textView = [[[NSTextView alloc] initWithFrame:NSMakeRect(0.0, 0.0, 128.0, 128.0)] autorelease];
	[[textView textStorage] setAttributedString:attributedString];
	NSAttributedString *accessibilityString = [textView
		accessibilityAttributeValue:NSAccessibilityAttributedStringForRangeParameterizedAttribute
		forParameter:[NSValue valueWithRange:NSMakeRange(0, [attributedString length])]];
	return accessibilityString;
}

- (NSAttributedString *)defaultAttributedStringWithValue:(id)value forAttribute:(NSString *)attribute
{
	NSParameterAssert(nil != value);
	NSParameterAssert(nil != attribute);
	NSDictionary *attributes = [NSDictionary dictionaryWithObject:value forKey:attribute];
	return [[[NSAttributedString alloc] initWithString:@"test" attributes:attributes] autorelease];
}

- (void)disable_testForegroundColorAttribute
{
	NSAttributedString *attributedString = [self defaultAttributedStringWithValue:[NSColor redColor] forAttribute:NSForegroundColorAttributeName];
	NSAttributedString *accessibilityString = [self accessibilityAttributedStringFromAttributedString:attributedString];
	NSAttributedString *convertedString = [accessibilityString attributedStringByUsingAppKitAttributes];
	STAssertEqualObjects(convertedString, attributedString, nil);
}

@end
