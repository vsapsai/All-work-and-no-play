//
//  UIElementUtilities.m
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/8/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import "UIElementUtilities.h"
#import "AXValueWrapper.h"

@implementation UIElementUtilities

+ (NSArray *)attributeNamesOfUIElement:(AXUIElementRef)element
{
    NSArray *attributeNames = nil;
    AXUIElementCopyAttributeNames(element, (CFArrayRef *)&attributeNames);
    return [attributeNames autorelease];
}

+ (id)valueOfAttribute:(NSString *)attribute ofUIElement:(AXUIElementRef)element
{
	id result = nil;
	NSArray *attributeNames = [UIElementUtilities attributeNamesOfUIElement:element];

	if ([attributeNames containsObject:attribute])
	{
		AXUIElementCopyAttributeValue(element, (CFStringRef)attribute, (CFTypeRef *)&result);
		[result autorelease];
	}

    return result;
}

+ (NSArray *)childrenOfUIElement:(AXUIElementRef)element
{
	return (NSArray *)[UIElementUtilities valueOfAttribute:NSAccessibilityChildrenAttribute ofUIElement:element];
}

+ (NSString *)roleOfUIElement:(AXUIElementRef)element
{
	return (NSString *)[UIElementUtilities valueOfAttribute:NSAccessibilityRoleAttribute ofUIElement:element];
}

+ (id)valueOfUIElement:(AXUIElementRef)element
{
	return [UIElementUtilities valueOfAttribute:NSAccessibilityValueAttribute ofUIElement:element];
}

#pragma mark Parameterized attributes

+ (NSArray *)parameterizedAttributeNamesOfUIElement:(AXUIElementRef)element
{
	NSArray *attributeNames = nil;
	AXUIElementCopyParameterizedAttributeNames(element, (CFArrayRef *)&attributeNames);
	return [attributeNames autorelease];
}

+ (id)valueOfParameterizedAttribute:(NSString *)attribute ofUIElement:(AXUIElementRef)element parameter:(CFTypeRef)parameter
{
	id result = nil;
	NSArray *attributeNames = [UIElementUtilities parameterizedAttributeNamesOfUIElement:element];
	if ([attributeNames containsObject:attribute])
	{
		AXUIElementCopyParameterizedAttributeValue(element, (CFStringRef)attribute, parameter, (CFTypeRef *)&result);
		[result autorelease];
	}
	return result;
}

+ (NSAttributedString *)attributedStringFromAccessibilityAttributedString:(NSAttributedString *)accessibilityString
{
	NSAttributedString *result = nil;
	if (nil != accessibilityString)
	{
		result = accessibilityString;//[[[NSAttributedString alloc] initWithString:[accessibilityString string]] autorelease];
	}
	return result;
}

+ (NSAttributedString *)attributedStringOfUIElement:(AXUIElementRef)element atRange:(NSRange)range
{
	AXValueWrapper *rangeWrapper = [AXValueWrapper wrapperWithNSValue:[NSValue valueWithRange:range]];
	NSAttributedString *attributedString = [UIElementUtilities valueOfParameterizedAttribute:NSAccessibilityAttributedStringForRangeParameterizedAttribute ofUIElement:element parameter:rangeWrapper.AXValue];
	return [UIElementUtilities attributedStringFromAccessibilityAttributedString:attributedString];
}

@end
