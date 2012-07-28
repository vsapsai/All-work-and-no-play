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
#import "WPImageWindow.h"
#import "NSScreen+WPConvertingCoordinates.h"


static NSString *const kWPObservedApplicationBundleIdentifier = @"com.apple.dt.Xcode";

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

- (AXUIElementWrapper *)textAreaElement:(AXUIElementWrapper *)uiElement
{
	AXUIElementWrapper *result = nil;
	if ([[uiElement role] isEqualToString:NSAccessibilityTextAreaRole])
	{
		result = uiElement;
	}
	else
	{
		NSArray *children = [uiElement children];
		for (AXUIElementWrapper *child in children)
		{
			result = [self textAreaElement:child];
			if (nil != result)
			{
				break;
			}
		}
	}
	return result;
}

- (WPWindowRepresentation *)frontMostVisibleWindowForApplication:(pid_t)applicationPid
{
	NSArray *windows = [WPWindowRepresentation windowRepresentationsForApplicationWithPid:applicationPid];
	return (([windows count] > 0) ? [windows objectAtIndex:0] : nil);
}

- (NSImage *)imageWithImageRep:(NSImageRep *)imageRep
{
	NSImage *result = nil;
	if (nil != imageRep)
	{
		result = [[[NSImage alloc] initWithSize:imageRep.size] autorelease];
		[result addRepresentation:imageRep];
	}
	return result;
}

- (void)drawAttributedString:(NSAttributedString *)attributedString inRect:(NSRect)rect inImage:(NSImage *)image
{
	[image lockFocusFlipped:YES];
	[NSGraphicsContext saveGraphicsState];

	[[NSColor whiteColor] set];
	NSRectFill(rect);
	[attributedString drawInRect:rect];

	[NSGraphicsContext restoreGraphicsState];
	[image unlockFocus];
}

- (void)displaySnapshot:(NSImage *)snapshot ofWindow:(WPWindowRepresentation *)window
{
	WPImageWindow *imageWindow = [[WPImageWindow alloc] initWithImage:snapshot];
	NSPoint topLeftWindowPoint = [[imageWindow screen] convertFlippedPoint:window.windowBounds.origin];
	[imageWindow setFrameTopLeftPoint:topLeftWindowPoint];
	[imageWindow orderFront:nil];
}

- (IBAction)run:(id)sender
{
	NSRunningApplication *application = [[NSRunningApplication runningApplicationsWithBundleIdentifier:kWPObservedApplicationBundleIdentifier] lastObject];
	pid_t applicationPid = application.processIdentifier;
	if (-1 != applicationPid)
	{
		AXUIElementWrapper *applicationElement = [AXUIElementWrapper wrapperForApplication:applicationPid];
		if (nil != applicationElement)
		{
			AXUIElementWrapper *textAreaElement = [self textAreaElement:applicationElement];
			if (nil != textAreaElement)
			{
				NSValue *visibleRangeValue = [textAreaElement visibleCharacterRange];
				if (nil != visibleRangeValue)
				{
					WPWindowRepresentation *window = [self frontMostVisibleWindowForApplication:applicationPid];
					NSImage *windowImage = [self imageWithImageRep:[window windowImageRep]];

					// Obtain text to draw.
					NSRange visibleRange = [visibleRangeValue rangeValue];
					NSAttributedString *textAreaContent = [textAreaElement attributedStringForRange:visibleRange];
					textAreaContent = [self allWorkAndNoPlayStringFrom:textAreaContent];

					// Obtain text position.
					NSValue *bounds = [textAreaElement boundsForRange:visibleRange];
					NSAssert(nil != bounds, @"I am sick of nested ifs, let's assume nothing wrong will happen");
					NSRect boundsRect = [bounds rectValue];
					boundsRect.origin = [window convertFlippedScreenToBase:boundsRect.origin];
					
					// Draw attributed string.
					[self drawAttributedString:textAreaContent inRect:boundsRect inImage:windowImage];
					
					[self displaySnapshot:windowImage ofWindow:window];
				}

//				NSString *text = [textAreaElement elementValue];
//				NSAttributedString *textAreaContent = [textAreaElement attributedStringForRange:NSMakeRange(0, [text length])];
//				[[self.textView textStorage] setAttributedString:[self allWorkAndNoPlayStringFrom:textAreaContent]];
			}
			else
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

#pragma mark -

- (NSAttributedString *)allWorkAndNoPlayStringFrom:(NSAttributedString *)string
{
	NSParameterAssert(nil != string);
	NSString *pattern = @"All work and no play makes Jack a dull boy";
	WPPatternApplicator *patternApplicator = [[[WPPatternApplicator alloc] initWithPattern:pattern attributedString:string] autorelease];
	return [patternApplicator attributedStringByApplyingPattern];
}

@end
