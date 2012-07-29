//
//  WPAppDelegate.m
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/8/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import "WPAppDelegate.h"
#import "AXUIElementWrapper.h"
#import "WPPatternApplicator.h"
#import "WPWindowRepresentation.h"
#import "WPWindowScreenshot.h"
#import "WPImageWindow.h"
#import "NSScreen+WPConvertingCoordinates.h"


static NSString *const kWPObservedApplicationBundleIdentifier = @"com.apple.dt.Xcode";

// These keys are also specified in MainMenu.xib for array controller.
static NSString *const kWPTitleKey = @"title";
static NSString *const kWPContentKey = @"content";

@interface WPAppDelegate()
- (NSAttributedString *)allWorkAndNoPlayStringFrom:(NSAttributedString *)string;
@end

@implementation WPAppDelegate

@synthesize window = _window;
@synthesize arrayController = _arrayController;
@synthesize predefinedTextAreasContent = _predefinedTextAreasContent;

- (void)dealloc
{
	self.predefinedTextAreasContent = nil;
    [super dealloc];
}
	
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	self.predefinedTextAreasContent = [NSMutableArray array];
}

#pragma mark -

- (void)collectTextAreaElements:(AXUIElementWrapper *)uiElement inAccumulator:(NSMutableArray *)accumulator
{
	if ([[uiElement role] isEqualToString:NSAccessibilityTextAreaRole])
	{
		[accumulator addObject:uiElement];
	}
	else
	{
		NSArray *children = [uiElement children];
		for (AXUIElementWrapper *child in children)
		{
			[self collectTextAreaElements:child inAccumulator:accumulator];
		}
	}
}

- (NSArray *)applicationTextAreaElements:(AXUIElementWrapper *)applicationElement
{
	NSMutableArray *result = [NSMutableArray array];
	[self collectTextAreaElements:applicationElement inAccumulator:result];
	return [[result copy] autorelease];
}

- (WPWindowRepresentation *)frontMostVisibleWindowForApplication:(pid_t)applicationPid
{
	NSArray *windows = [WPWindowRepresentation windowRepresentationsForApplicationWithPid:applicationPid];
	return (([windows count] > 0) ? [windows objectAtIndex:0] : nil);
}

// Returns visible range but with the first and the last visible lines omitted.
- (NSRange)visibleRangeWithTrimmedLinesForUIElement:(AXUIElementWrapper *)element
{
	NSValue *visibleRangeValue = [element visibleCharacterRange];
	NSAssert(nil != visibleRangeValue, @"UI element should provide visible range");
	NSRange visibleRange = [visibleRangeValue rangeValue];
	NSRange result = visibleRange;
	if (result.length > 0)
	{
		do
		{
			// Trim the last line.
			NSNumber *lastLine = [element lineForIndex:(NSMaxRange(result) - 1)];
			NSAssert(nil != lastLine, @"UI element should provide line for index");
			NSValue *lastLineRangeValue = [element rangeForLine:[lastLine integerValue]];
			NSAssert(nil != lastLineRangeValue, @"UI element should provide range for line");
			NSRange lastLineRange = [lastLineRangeValue rangeValue];
			BOOL hasVisibleRangeOtherLinesExceptLastLine = (lastLineRange.location >= result.location);
			if (hasVisibleRangeOtherLinesExceptLastLine)
			{
				// result.location + result.length == lastLineRange.location
				result.length = lastLineRange.location - result.location;
			}
			else
			{
				// Visible range is too small.
				result.length = 0;
				break;
			}

			// Trim the first line.
			NSNumber *firstLine = [element lineForIndex:result.location];
			NSAssert(nil != firstLine, @"UI element should provide line for index");
			NSValue *firstLineRangeValue = [element rangeForLine:[firstLine integerValue]];
			NSAssert(nil != firstLineRangeValue, @"UI element should provide range for line");
			NSRange firstLineRange = [firstLineRangeValue rangeValue];
			BOOL hasVisibleRangeOtherLinesExceptFirstLine = (NSMaxRange(firstLineRange) < NSMaxRange(result));
			if (hasVisibleRangeOtherLinesExceptFirstLine)
			{
				NSInteger offset = NSMaxRange(firstLineRange) - result.location;
				result.location += offset;
				result.length -= offset;
			}
			else
			{
				// Visible range is too small.
				result.length = 0;
				break;
			}
		}
		while (NO);
	}
	return result;
}

- (void)displaySnapshot:(NSImage *)snapshot ofWindow:(WPWindowRepresentation *)window
{
	WPImageWindow *imageWindow = [[WPImageWindow alloc] initWithImage:snapshot];
	NSPoint topLeftWindowPoint = [[imageWindow screen] convertFlippedPoint:window.windowBounds.origin];
	[imageWindow setFrameTopLeftPoint:topLeftWindowPoint];
	[imageWindow orderFront:nil];
}

- (IBAction)showScreenshot:(id)sender
{
	NSRunningApplication *application = [[NSRunningApplication runningApplicationsWithBundleIdentifier:kWPObservedApplicationBundleIdentifier] lastObject];
	pid_t applicationPid = application.processIdentifier;
	if (-1 != applicationPid)
	{
		AXUIElementWrapper *applicationElement = [AXUIElementWrapper wrapperForApplication:applicationPid];
		if (nil != applicationElement)
		{
			WPWindowRepresentation *window = [self frontMostVisibleWindowForApplication:applicationPid];
			WPWindowScreenshot *windowScreenshot = [[[WPWindowScreenshot alloc] initWithWindowRepresentation:window] autorelease];

			NSArray *textAreaElements = [self applicationTextAreaElements:applicationElement];
			for (AXUIElementWrapper *textAreaElement in textAreaElements)
			{
				// Obtain text to draw.
				NSRange visibleRange = [self visibleRangeWithTrimmedLinesForUIElement:textAreaElement];
				NSAttributedString *textAreaContent = [textAreaElement attributedStringForRange:visibleRange];
				textAreaContent = [self allWorkAndNoPlayStringFrom:textAreaContent];

				// Obtain text position.
				NSValue *bounds = [textAreaElement boundsForRange:visibleRange];
				NSAssert(nil != bounds, @"I am sick of nested ifs, let's assume nothing wrong will happen");
				NSRect boundsRect = [bounds rectValue];

				// Draw attributed string.
				[windowScreenshot drawAttributedString:textAreaContent inRect:boundsRect];
			}

			[self displaySnapshot:windowScreenshot.windowImage ofWindow:window];
			if (0 == [textAreaElements count])
			{
				NSLog(@"Didn't found text area");
			}
		}
		else
		{
			NSLog(@"Failed to create application AXUIElementWrapper");
		}
	}
	else
	{
		NSLog(@"%@ isn't launched", kWPObservedApplicationBundleIdentifier);
	}
}

- (IBAction)addTextAreaContent:(id)sender
{
	NSAttributedString *emptyAttributedString = [[[NSAttributedString alloc] initWithString:@""] autorelease];
	NSMutableDictionary *emptyRecord = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Text Area", kWPTitleKey, emptyAttributedString, kWPContentKey, nil];
	[self.arrayController addObject:emptyRecord];
}

#pragma mark -

- (NSAttributedString *)allWorkAndNoPlayStringFrom:(NSAttributedString *)string
{
	NSParameterAssert(nil != string);
	NSString *pattern = @"All work and no play makes Jack a dull boy";
	WPPatternApplicator *patternApplicator = [[[WPPatternApplicator alloc] initWithPattern:pattern attributedString:string] autorelease];
	return [patternApplicator attributedStringByApplyingPattern];
}

@end
