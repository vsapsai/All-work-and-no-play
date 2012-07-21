//
//  WPPatternApplicator.h
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/20/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPPatternApplicator : NSObject
{
@private
	NSAttributedString *_attributedString;
	NSArray *_pattern; // array of NSString
}

- (id)initWithPattern:(NSString *)patternString attributedString:(NSAttributedString *)attributedString;

- (NSAttributedString *)attributedStringByApplyingPattern;
@end
