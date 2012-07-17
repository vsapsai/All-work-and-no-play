//
//  WPAppDelegate.m
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/8/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import "WPAppDelegate.h"
#import "UIElementUtilities.h"


@interface WPAppDelegate()
- (NSAttributedString *)allWorkAndNoPlayStringFrom:(NSAttributedString *)string;
@end

@implementation WPAppDelegate

@synthesize window = _window;
@synthesize textView = _textView;

- (void)dealloc
{
    [super dealloc];
}
	
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
}

- (AXUIElementRef)textAreaElement:(AXUIElementRef)uiElement
{
	AXUIElementRef result = NULL;
	if ([[UIElementUtilities roleOfUIElement:uiElement] isEqualToString:NSAccessibilityTextAreaRole])
	{
		result = uiElement;
	}
	else
	{
		NSArray *children = [UIElementUtilities childrenOfUIElement:uiElement];
		for (NSInteger i = 0; i < [children count]; i++)
		{
			AXUIElementRef child = (AXUIElementRef)[children objectAtIndex:i];
			result = [self textAreaElement:child];
			if (NULL != result)
			{
				break;
			}
		}
	}
	return result;
}

- (IBAction)run:(id)sender
{
	NSRunningApplication *xcodeApplication = [[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.apple.dt.Xcode"] lastObject];
	pid_t xcodePid = xcodeApplication.processIdentifier;
	if (-1 != xcodePid)
	{
		AXUIElementRef xcodeElement = AXUIElementCreateApplication(xcodePid);
		if (NULL != xcodeElement)
		{
			AXUIElementRef textAreaElement = [self textAreaElement:xcodeElement];
			if (NULL != textAreaElement)
			{
				NSString *text = [UIElementUtilities valueOfUIElement:textAreaElement];
				NSAttributedString *textAreaContent = [UIElementUtilities attributedStringOfUIElement:textAreaElement atRange:NSMakeRange(0, [text length])];
				[[self.textView textStorage] setAttributedString:[self allWorkAndNoPlayStringFrom:textAreaContent]];
			}
			else
			{
				NSLog(@"Didn't found text area");
			}
			CFRelease(xcodeElement);
		}
		else
		{
			NSLog(@"Failed to create Xcode AXUIElementRef");
		}
	}
	else
	{
		NSLog(@"Xcode isn't launched");
	}
}

#pragma mark -

- (BOOL)isUpperCaseCharacter:(unichar)character
{
	return (('A' <= character) && (character <= 'Z'));
}

- (BOOL)isLowerCaseCharacter:(unichar)character
{
	return (('a' <= character) && (character <= 'z'));
}

- (NSArray *)splitStringIntoCharacters:(NSString *)string
{
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:[string length]];
	for (NSInteger i = 0; i < [string length]; i++)
	{
		[result addObject:[string substringWithRange:NSMakeRange(i, 1)]];
	}
	return [[result copy] autorelease];
}

- (NSAttributedString *)allWorkAndNoPlayStringFrom:(NSAttributedString *)string
{
	NSParameterAssert(nil != string);
	NSString *pattern = @"All work and no play makes Jack a dull boy";
	NSArray *patternArray = [self splitStringIntoCharacters:[[pattern stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString]];
	NSInteger patternIndex = 0;
	NSMutableAttributedString *result = [[string mutableCopy] autorelease];
	NSString *plainString = [string string];
	for (NSInteger i = 0; i < [plainString length]; i++)
	{
		unichar character = [plainString characterAtIndex:i];
		if ([self isLowerCaseCharacter:character])
		{
			[result replaceCharactersInRange:NSMakeRange(i, 1) withString:[patternArray objectAtIndex:patternIndex]];
			patternIndex = ((patternIndex + 1) % [patternArray count]);
		}
		else if ([self isUpperCaseCharacter:character])
		{
			[result replaceCharactersInRange:NSMakeRange(i, 1) withString:[[patternArray objectAtIndex:patternIndex] uppercaseString]];
			patternIndex = ((patternIndex + 1) % [patternArray count]);
		}
	}
	return [[result copy] autorelease];
}

@end
