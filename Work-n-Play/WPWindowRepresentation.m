//
//  WPWindowRepresentation.m
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/21/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import "WPWindowRepresentation.h"

@interface WPWindowRepresentation()
@property (copy, nonatomic) NSDictionary *windowInfo;
@end

@implementation WPWindowRepresentation

@synthesize windowInfo = _windowInfo;

@dynamic windowID;
@dynamic windowBounds;

- (id)initWithWindowInfo:(NSDictionary *)windowInfo
{
	self = [super init];
	if (nil != self)
	{
		self.windowInfo = windowInfo;
	}
	return self;
}

+ (NSArray *)windowRepresentationsForApplicationWithPid:(pid_t)applicationPid
{
	NSMutableArray *result = [NSMutableArray array];
	NSArray *allWindows = [(NSArray *)CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID) autorelease];
	for (NSDictionary *windowInfo in allWindows)
	{
		NSNumber *ownerPid = [windowInfo objectForKey:(NSString *)kCGWindowOwnerPID];
		if ((nil != ownerPid) && ([ownerPid intValue] == applicationPid))
		{
			[result addObject:[[[WPWindowRepresentation alloc] initWithWindowInfo:windowInfo] autorelease]];
		}
	}
	return [[result copy] autorelease];
}

- (void)dealloc
{
    self.windowInfo = nil;
    [super dealloc];
}

#pragma mark -

- (CGWindowID)windowID
{
	NSNumber *windowNumber = [self.windowInfo objectForKey:(NSString *)kCGWindowNumber];
	return ((nil != windowNumber) ? [windowNumber intValue] : kCGNullWindowID);
}

- (NSRect)windowBounds
{
	CGRect result = CGRectZero;
	CFDictionaryRef boundsDictionaryRepresentation = (CFDictionaryRef)[self.windowInfo objectForKey:(NSString *)kCGWindowBounds];
	CGRectMakeWithDictionaryRepresentation(boundsDictionaryRepresentation, &result);
	return NSRectFromCGRect(result);
}

- (NSBitmapImageRep *)windowImageRep
{
	NSBitmapImageRep *result = nil;
	CGWindowID windowIDs[] = {self.windowID};
	// CGWindowListCreateImageFromArray expect a CFArray of *CGWindowID*, not
	// CGWindowID wrapped in a CF/NSNumber.  Hence we typecast our array above
	// (to avoid the compiler warning) and use NULL CFArray callbacks (because
	// CGWindowID isn't a CF type) to avoid retain/release.
	CFArrayRef windowIDsArray = CFArrayCreate(kCFAllocatorDefault, (const void**)windowIDs, 1, NULL);
	if (NULL != windowIDsArray)
	{
		CGImageRef imageRef = CGWindowListCreateImageFromArray(CGRectNull/*screenBounds*/, windowIDsArray, kCGWindowImageBoundsIgnoreFraming/*imageOption*/);
		if (NULL != imageRef)
		{
			result = [[[NSBitmapImageRep alloc] initWithCGImage:imageRef] autorelease];
			CFRelease(imageRef);
		}
		CFRelease(windowIDsArray);
	}
	return result;
}

#pragma mark -

- (NSPoint)convertFlippedScreenToBase:(NSPoint)flippedScreenPoint
{
	NSRect windowRect = self.windowBounds;
	NSPoint result = NSMakePoint(flippedScreenPoint.x - windowRect.origin.x, flippedScreenPoint.y - windowRect.origin.y);
	return result;
}

@end
