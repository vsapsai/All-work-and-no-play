//
//  WPImageWindow.h
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/28/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import <AppKit/AppKit.h>

// Window which just displays an image.  Hasn't border, shadow.
@interface WPImageWindow : NSWindow
- (id)initWithImage:(NSImage *)image;
@end
