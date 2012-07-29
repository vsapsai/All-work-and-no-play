//
//  WPGradientBar.m
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/29/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import "WPGradientBar.h"

@implementation WPGradientBar

- (void)drawRect:(NSRect)dirtyRect
{
	[NSGraphicsContext saveGraphicsState];
	NSButtonCell *drawingCell = [[[NSButtonCell alloc] init] autorelease];
	[drawingCell setTitle:@""];
	[drawingCell setEnabled:YES];
	[drawingCell setBezelStyle:NSSmallSquareBezelStyle];
	[drawingCell drawWithFrame:[self bounds] inView:nil];
	[NSGraphicsContext restoreGraphicsState];
}

@end
