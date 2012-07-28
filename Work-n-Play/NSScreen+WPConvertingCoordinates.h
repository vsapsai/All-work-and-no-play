//
//  NSScreen+WPConvertingCoordinates.h
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/28/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface NSScreen (WPConvertingCoordinates)
// flippedPoint is a point in flipped coordinate system, i.e. origin in top left
// corner, Y axis goes down.  Returns point in usual screen coordinate system,
// i.e. origin in bottom left corner.
- (NSPoint)convertFlippedPoint:(NSPoint)flippedPoint;
@end
