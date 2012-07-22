//
//  AXUIElementWrapper.m
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/22/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import "AXUIElementWrapper.h"
#import "AXValueWrapper.h"
#import "NSAttributedString+Accessibility.h"

@interface AXUIElementWrapper()
- (void)setUIElement:(AXUIElementRef)uiElement;
@end

#pragma mark -

@implementation AXUIElementWrapper

- (id)initWithUIElement:(AXUIElementRef)uiElement
{
	self = [super init];
	if (nil != self)
	{
		[self setUIElement:uiElement];
	}
	return self;
}

+ (id)wrapperWithUIElement:(AXUIElementRef)uiElement
{
	return [[[self alloc] initWithUIElement:uiElement] autorelease];
}

+ (id)wrapperForApplication:(pid_t)applicationPid
{
	AXUIElementWrapper *result = nil;
	AXUIElementRef applicationElement = AXUIElementCreateApplication(applicationPid);
	if (NULL != applicationElement)
	{
		result = [self wrapperWithUIElement:applicationElement];
		CFRelease(applicationElement);
	}
	return result;
}

- (void)dealloc
{
    [self setUIElement:NULL];
    [super dealloc];
}

#pragma mark -

- (AXUIElementRef)UIElement
{
	return _UIElement;
}

- (void)setUIElement:(AXUIElementRef)uiElement
{
	if (_UIElement != uiElement)
	{
		if (NULL != _UIElement)
		{
			CFRelease(_UIElement);
		}
		_UIElement = ((NULL != uiElement) ? CFRetain(uiElement) : NULL);
	}
}

#pragma mark -
#pragma mark Attributes

- (NSArray *)attributeNames
{
	NSArray *result = nil;
	AXUIElementCopyAttributeNames(self.UIElement, (CFArrayRef *)&result);
	return [result autorelease];
}

- (id)attributeValue:(NSString *)attribute
{
	id result = nil;
	NSArray *attributeNames = [self attributeNames];
	if ([attributeNames containsObject:attribute])
	{
		AXUIElementCopyAttributeValue(self.UIElement, (CFStringRef)attribute, (CFTypeRef *)&result);
		[result autorelease];
	}
	return result;
}

- (id)elementValue
{
	return [self attributeValue:NSAccessibilityValueAttribute];
}

- (NSArray *)children
{
	NSMutableArray *result = nil;
	NSArray *rawChildren = [self attributeValue:NSAccessibilityChildrenAttribute];
	if ([rawChildren count] > 0)
	{
		result = [NSMutableArray arrayWithCapacity:[rawChildren count]];
		for (NSInteger i = 0; i < [rawChildren count]; i++)
		{
			AXUIElementRef element = (AXUIElementRef)[rawChildren objectAtIndex:i];
			AXUIElementWrapper *elementWrapper = [AXUIElementWrapper wrapperWithUIElement:element];
			[result addObject:elementWrapper];
		}
	}
	return [[result copy] autorelease];
}

- (NSString *)role
{
	return [self attributeValue:NSAccessibilityRoleAttribute];
}

- (NSValue *)visibleCharacterRange
{
	AXValueRef rangeRef = (AXValueRef)[self attributeValue:NSAccessibilityVisibleCharacterRangeAttribute];
	AXValueWrapper *rangeWrapper = [AXValueWrapper wrapperWithAXValueRef:rangeRef];
	return rangeWrapper.value;
}

#pragma mark -
#pragma mark Parameterized attributes

- (NSArray *)parameterizedAttributeNames
{
	NSArray *result = nil;
	AXUIElementCopyParameterizedAttributeNames(self.UIElement, (CFArrayRef *)&result);
	return result;
}

// Type of parameter is CFTypeRef because parameter is usually not toll-free
// bridged.  For example, AXValueRef is not toll-free bridged with NSValue.
- (id)parameterizedAttributeValue:(NSString *)attribute forParameter:(CFTypeRef)parameter
{
	id result = nil;
	NSArray *attributeNames = [self parameterizedAttributeNames];
	if ([attributeNames containsObject:attribute])
	{
		AXUIElementCopyParameterizedAttributeValue(self.UIElement, (CFStringRef)attribute, parameter, (CFTypeRef *)&result);
		[result autorelease];
	}
	return result;
}

- (NSAttributedString *)attributedStringForRange:(NSRange)range
{
	AXValueWrapper *rangeWrapper = [AXValueWrapper wrapperWithNSValue:[NSValue valueWithRange:range]];
	NSAttributedString *attributedString = [self parameterizedAttributeValue:NSAccessibilityAttributedStringForRangeParameterizedAttribute forParameter:rangeWrapper.AXValue];
	return [attributedString attributedStringByUsingAppKitAttributes];
}

- (NSValue *)boundsForRange:(NSRange)range
{
	AXValueWrapper *rangeWrapper = [AXValueWrapper wrapperWithNSValue:[NSValue valueWithRange:range]];
	AXValueRef boundsRef = (AXValueRef)[self parameterizedAttributeValue:NSAccessibilityBoundsForRangeParameterizedAttribute forParameter:rangeWrapper.AXValue];
	AXValueWrapper *boundsWrapper = [AXValueWrapper wrapperWithAXValueRef:boundsRef];
	return boundsWrapper.value;
}

@end
