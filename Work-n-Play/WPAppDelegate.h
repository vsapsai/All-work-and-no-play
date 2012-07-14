//
//  WPAppDelegate.h
//  Work-n-Play
//
//  Created by Volodymyr Sapsai on 7/8/12.
//  Copyright (c) 2012 Volodymyr Sapsai. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WPAppDelegate : NSObject <NSApplicationDelegate>

@property (assign, nonatomic) IBOutlet NSWindow *window;
@property (assign, nonatomic) IBOutlet NSTextView *textView;

- (IBAction)run:(id)sender;

@end
