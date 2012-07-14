//
//  UIElementUtilities.h
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/8/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIElementUtilities : NSObject

+ (NSArray *)attributeNamesOfUIElement:(AXUIElementRef)element;

+ (id)valueOfUIElement:(AXUIElementRef)element;
+ (NSArray *)childrenOfUIElement:(AXUIElementRef)element;
+ (NSString *)roleOfUIElement:(AXUIElementRef)element;

+ (id)valueOfParameterizedAttribute:(NSString *)attribute ofUIElement:(AXUIElementRef)element parameter:(CFTypeRef)parameter;
+ (NSAttributedString *)attributedStringOfUIElement:(AXUIElementRef)element atRange:(NSRange)range;

@end
