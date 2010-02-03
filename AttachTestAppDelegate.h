//
//  AttachTestAppDelegate.h
//  AttachTest
//
//  Created by Johannes Fahrenkrug on 02.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface AttachTestAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	IBOutlet WebView *webView;
	IBOutlet NSTextField *label;
}

@property (assign) IBOutlet NSWindow *window;

@end
