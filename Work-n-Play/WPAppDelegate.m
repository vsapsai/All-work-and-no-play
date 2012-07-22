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

- (void)storeFrontMostWindowScreenshot:(pid_t)applicationPid
{
	NSArray *windows = [WPWindowRepresentation windowRepresentationsForApplicationWithPid:applicationPid];
	if ([windows count] > 0)
	{
		WPWindowRepresentation *frontMostWindow = [windows objectAtIndex:0];
		NSBitmapImageRep *windowScreenShot = [frontMostWindow windowImageRep];
		[[windowScreenShot TIFFRepresentation] writeToFile:@"/Users/vsapsay/Desktop/xcode.tiff" atomically:YES];
	}
}

- (IBAction)run:(id)sender
{
	NSRunningApplication *application = [[NSRunningApplication runningApplicationsWithBundleIdentifier:kWPObservedApplicationBundleIdentifier] lastObject];
	pid_t applicationPid = application.processIdentifier;
	if (-1 != applicationPid)
	{
		//[self storeFrontMostWindowScreenshot:applicationPid];

		AXUIElementWrapper *applicationElement = [AXUIElementWrapper wrapperForApplication:applicationPid];
		if (nil != applicationElement)
		{
			AXUIElementWrapper *textAreaElement = [self textAreaElement:applicationElement];
			if (nil != textAreaElement)
			{
				NSValue *visibleRange = [textAreaElement visibleCharacterRange];
				if (nil != visibleRange)
				{
					NSValue *bounds = [textAreaElement boundsForRange:[visibleRange rangeValue]];
					if (nil != bounds)
					{
						NSRect boundsRect = [bounds rectValue];
						NSLog(@"visible rect = %@", NSStringFromRect(boundsRect));
					}
				}

				NSString *text = [textAreaElement elementValue];
				NSAttributedString *textAreaContent = [textAreaElement attributedStringForRange:NSMakeRange(0, [text length])];
				[[self.textView textStorage] setAttributedString:[self allWorkAndNoPlayStringFrom:textAreaContent]];
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
