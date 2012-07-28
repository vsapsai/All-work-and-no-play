//
//  WPImageWindow.m
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/28/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import "WPImageWindow.h"

@implementation WPImageWindow

- (id)initWithImage:(NSImage *)image
{
	NSParameterAssert(nil != image);
	NSSize imageSize = [image size];
	NSRect contentRect = NSMakeRect(0.0, 0.0, imageSize.width, imageSize.height);
	self = [self initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
	if (nil != self)
	{
		NSImageView *imageView = [[[NSImageView alloc] initWithFrame:contentRect] autorelease];
		imageView.image = image;
		[self.contentView addSubview:imageView];

		self.opaque = NO;
		self.hasShadow = NO;
	}
	return self;
}

@end
