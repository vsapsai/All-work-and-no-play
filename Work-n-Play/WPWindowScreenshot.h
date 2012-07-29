//
//  WPWindowScreenshot.h
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/29/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WPWindowRepresentation;

// To manipulate window screenshot we usually need both NSImage and
// WPWindowRepresentation.  For example, to translate coordinates.
// WPWindowScreenshot's responsibility is to join mentioned objects.
@interface WPWindowScreenshot : NSObject
{
@private
	WPWindowRepresentation *_windowRepresentation;
	NSImage *_windowImage;
}
@property (retain, readonly, nonatomic) NSImage *windowImage;

- (id)initWithWindowRepresentation:(WPWindowRepresentation *)windowRep;

// rect is specified in screen flipped coordinates.
- (void)drawAttributedString:(NSAttributedString *)attributedString inRect:(NSRect)rect;

@end
