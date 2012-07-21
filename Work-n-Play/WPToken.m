//
//  WPToken.m
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/21/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import "WPToken.h"

@implementation WPToken

@synthesize range = _range;
@synthesize content = _content;

- (id)init
{
	self = [super init];
	if (nil != self)
	{
		self.range = NSMakeRange(NSNotFound, 0);
	}
	return self;
}

- (void)dealloc
{
    self.content = nil;
    [super dealloc];
}

@end
