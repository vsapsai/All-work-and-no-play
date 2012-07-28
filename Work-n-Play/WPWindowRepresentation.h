//
//  WPWindowRepresentation.h
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/21/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import <Foundation/Foundation.h>

// Represents a window in current user session.
@interface WPWindowRepresentation : NSObject
{
@private
	NSDictionary *_windowInfo;
}

@property (readonly, nonatomic) CGWindowID windowID;
@property (readonly, nonatomic) NSRect windowBounds;

- (id)initWithWindowInfo:(NSDictionary *)windowInfo;
+ (NSArray *)windowRepresentationsForApplicationWithPid:(pid_t)applicationPid;

- (NSBitmapImageRep *)windowImageRep;

// Note that base is flipped too.
- (NSPoint)convertFlippedScreenToBase:(NSPoint)flippedScreenPoint;

@end
