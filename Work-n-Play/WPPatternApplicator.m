//
//  WPPatternApplicator.m
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/20/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import "WPPatternApplicator.h"
#import "WPToken.h"

@interface WPPatternApplicator()
@property (retain, nonatomic) NSAttributedString *attributedString;
@property (retain, nonatomic) NSArray *pattern;
@end

@implementation WPPatternApplicator

@synthesize attributedString = _attributedString;
@synthesize pattern = _pattern;

- (id)initWithPattern:(NSString *)patternString attributedString:(NSAttributedString *)attributedString
{
	self = [super init];
	if (nil != self)
	{
		self.attributedString = attributedString;
		self.pattern = [[patternString lowercaseString] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	}
	return self;
}

- (void)dealloc
{
    self.attributedString = nil;
	self.pattern = nil;
    [super dealloc];
}

#pragma mark -

- (NSString *)componentsJoinedInCamelCaseStyle:(NSArray *)components
{
	NSString *result = @"";
	if ([components count] > 0)
	{
		NSMutableArray *capitalizedComponents = [[[components valueForKey:@"capitalizedString"] mutableCopy] autorelease];
		// First component should not be capitalized.
		[capitalizedComponents replaceObjectAtIndex:0 withObject:[components objectAtIndex:0]];
		result = [capitalizedComponents componentsJoinedByString:@""];
	}
	return result;
}

- (BOOL)isLetterCharacter:(unichar)character
{
	return ((('A' <= character) && (character <= 'Z')) ||
			(('a' <= character) && (character <= 'z')));
}

- (WPToken *)nextWordTokenStartingFromPosition:(NSInteger)startPosition inString:(NSString *)string
{
	WPToken *token = nil;
	for (NSInteger position = startPosition; position < [string length]; position++)
	{
		unichar character = [string characterAtIndex:position];
		if ([self isLetterCharacter:character])
		{
			// Find end of word.
			NSInteger wordStartPosition = position;
			NSInteger wordPosition = wordStartPosition;
			for (wordPosition = wordStartPosition; wordPosition < [string length]; wordPosition++)
			{
				unichar wordCharacter = [string characterAtIndex:wordPosition];
				if (![self isLetterCharacter:wordCharacter])
				{
					break;
				}
			}
			// Don't take wordPosition because it points at the first
			// unnecessary character.
			NSRange wordRange = NSMakeRange(wordStartPosition, wordPosition - wordStartPosition);
			token = [[[WPToken alloc] init] autorelease];
			token.range = wordRange;
			token.content = [string substringWithRange:wordRange];
			break;
		}
	}
	return token;
}

- (NSArray *)componentsFromArray:(NSArray *)components startingFromIndex:(NSInteger)index toFillLength:(NSInteger)length
{
	NSParameterAssert([components count] > 0);
	for (NSString *component in components)
	{
		NSParameterAssert([component length] > 0);
	}
	NSParameterAssert((0 <= index) && (index < [components count]));
	NSParameterAssert(length > 0);

	NSInteger totalLength = 0;
	NSMutableArray *result = [NSMutableArray array];
	while (totalLength < length)
	{
		NSString *component = [components objectAtIndex:index];
		[result addObject:component];
		totalLength += [component length];
		index = (index + 1) % [components count];
	}
	return [[result copy] autorelease];
}

- (NSAttributedString *)attributedStringByApplyingPattern
{
	NSMutableAttributedString *result = [[self.attributedString mutableCopy] autorelease];
	NSInteger patternPosition = 0;
	NSInteger currentPosition = 0;
	WPToken *wordToken = [self nextWordTokenStartingFromPosition:currentPosition inString:[result string]];
	while (nil != wordToken)
	{
		// Find how to replace token.
		NSArray *replacementComponents = [self componentsFromArray:self.pattern startingFromIndex:patternPosition toFillLength:wordToken.range.length];
		patternPosition = (patternPosition + [replacementComponents count]) % [self.pattern count];
		NSString *replacement = [self componentsJoinedInCamelCaseStyle:replacementComponents];
		// Replace token.
		[result replaceCharactersInRange:wordToken.range withString:replacement];
		// Advance position.
		currentPosition = wordToken.range.location + [replacement length];
		wordToken = [self nextWordTokenStartingFromPosition:currentPosition inString:[result string]];
	}
	return [[result copy] autorelease];
}

@end
