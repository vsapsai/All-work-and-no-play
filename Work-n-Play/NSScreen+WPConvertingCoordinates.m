//
//  NSScreen+WPConvertingCoordinates.m
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/28/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import "NSScreen+WPConvertingCoordinates.h"

@implementation NSScreen (WPConvertingCoordinates)

- (NSPoint)convertFlippedPoint:(NSPoint)flippedPoint
{
	NSAffineTransform *transform = [NSAffineTransform transform];
	// Build transform to flipped coordinate system.
	[transform translateXBy:0.0 yBy:NSHeight([self frame])];
	[transform scaleXBy:1.0 yBy:-1.0];
	// Build transform from flipped coordinate system.
	[transform invert];
	return [transform transformPoint:flippedPoint];
}

@end
