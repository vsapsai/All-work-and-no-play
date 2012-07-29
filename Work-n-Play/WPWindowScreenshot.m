//
//  WPWindowScreenshot.m
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/29/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import "WPWindowScreenshot.h"
#import "WPWindowRepresentation.h"
#import "NSScreen+WPConvertingCoordinates.h"

@interface WPWindowScreenshot()
@property (retain, nonatomic) WPWindowRepresentation *windowRepresentation;
@property (retain, readwrite, nonatomic) NSImage *windowImage;

- (NSImage *)imageWithImageRep:(NSImageRep *)imageRep;
@end

@implementation WPWindowScreenshot

@synthesize windowRepresentation = _windowRepresentation;
@synthesize windowImage = _windowImage;

- (id)initWithWindowRepresentation:(WPWindowRepresentation *)windowRep
{
	NSParameterAssert(nil != windowRep);
	self = [super init];
	if (nil != self)
	{
		self.windowRepresentation = windowRep;
		self.windowImage = [self imageWithImageRep:[windowRep windowImageRep]];
	}
	return self;
}

- (void)dealloc
{
    self.windowRepresentation = nil;
	self.windowImage = nil;
    [super dealloc];
}

#pragma mark -

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

- (void)drawAttributedString:(NSAttributedString *)attributedString inRect:(NSRect)rect
{
	rect.origin = [self.windowRepresentation convertFlippedScreenToBase:rect.origin];
	NSImage *image = self.windowImage;
	[image lockFocusFlipped:YES];
	[NSGraphicsContext saveGraphicsState];

	[[NSColor whiteColor] set];
	NSRectFill(rect);
	[attributedString drawInRect:rect];

	[NSGraphicsContext restoreGraphicsState];
	[image unlockFocus];
}

@end
