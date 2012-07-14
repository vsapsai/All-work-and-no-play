//
//  NSAttributedString+Accessibility.m
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/14/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import "NSAttributedString+Accessibility.h"

static NSDictionary *ConvertToAppKitAttributes(NSDictionary *accessibilityAttributes);
static NSColor *CGColorRefToNSColor(CGColorRef colorRef);

@implementation NSAttributedString (Accessibility)

- (NSAttributedString *)attributedStringByUsingAppKitAttributes
{
	NSMutableAttributedString *result = [[[NSMutableAttributedString alloc] initWithString:[self string]] autorelease];
	[self enumerateAttributesInRange:NSMakeRange(0, [self length])
							 options:0
						  usingBlock:^(NSDictionary *attributes, NSRange range, BOOL *stop) {
							  NSDictionary *convertedAttributes = ConvertToAppKitAttributes(attributes);
							  [result addAttributes:convertedAttributes range:range];
						  }];
	return [[result copy] autorelease];
}

@end

NSDictionary *ConvertToAppKitAttributes(NSDictionary *accessibilityAttributes)
{
	NSMutableDictionary *result = [[accessibilityAttributes mutableCopy] autorelease];
	// NSAccessibilityForegroundColorTextAttribute
	CGColorRef foregroundColor = (CGColorRef)[accessibilityAttributes objectForKey:NSAccessibilityForegroundColorTextAttribute];
	if (NULL != foregroundColor)
	{
		[result setObject:CGColorRefToNSColor(foregroundColor) forKey:NSForegroundColorAttributeName];
	}
	return [[result copy] autorelease];
}

NSColor *CGColorRefToNSColor(CGColorRef colorRef)
{
	NSColor *result = nil;
	if (NULL != colorRef)
	{
		CGColorSpaceRef colorSpaceRef = CGColorGetColorSpace(colorRef);
		NSColorSpace *colorSpace = [[[NSColorSpace alloc] initWithCGColorSpace:colorSpaceRef] autorelease];
		const CGFloat *colorComponents = CGColorGetComponents(colorRef);
		size_t componentsCount = CGColorGetNumberOfComponents(colorRef);
		result = [NSColor colorWithColorSpace:colorSpace components:colorComponents count:componentsCount];
	}
	return result;
}
