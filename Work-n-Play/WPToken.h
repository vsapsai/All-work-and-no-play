//
//  WPToken.h
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/21/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import <Foundation/Foundation.h>

// WPToken doesn't contain any logic, it wraps some token data to make it more
// convenient to use.
@interface WPToken : NSObject
{
@private
	NSRange _range;
	NSString *_content;
}

@property (assign, nonatomic) NSRange range;
@property (copy, nonatomic) NSString *content;

@end
