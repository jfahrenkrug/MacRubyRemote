//
//  AttachTestAppDelegate.m
//  AttachTest
//
//  Created by Johannes Fahrenkrug on 02.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AttachTestAppDelegate.h"
#import <MacRuby/MacRuby.h>

@implementation AttachTestAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[[MacRuby sharedRuntime] evaluateFileAtPath:[[NSBundle mainBundle] pathForResource:@"spy" ofType:@"rb"]];
}


@end
