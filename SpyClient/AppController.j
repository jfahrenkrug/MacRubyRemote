/*
 * AppController.j
 * SpyClient
 *
 * Created by Johannes Fahrenkrug on February 3, 2010.
 * Copyright 2010, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "MultiLineCPTextField.j"


@implementation AppController : CPObject
{
    @outlet CPWindow    theWindow; //this "outlet" is connected automatically by the Cib
    @outlet CPTextField resultTextField;
    @outlet MultiLineCPTextField codeTextField;
    CPString receivedData;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // This is called when the application is done loading.
}

- (void)awakeFromCib
{
    // This is called when the cib is done loading.
    // You can implement this method on any object instantiated from a Cib.
    // It's a useful hook for setting up current UI values, and other things. 

    [resultTextField setLineBreakMode:CPLineBreakByWordWrapping];
}

- (@action)runCode:(id)sender
{

    var request = [CPURLRequest requestWithURL:"http://localhost:4567/run?code=" + escape([codeTextField stringValue])];
    [request setHTTPMethod:@"GET"];
    receivedData = nil;
    var loadConnection = [CPURLConnection connectionWithRequest:request delegate:self];
}

/* CPURLConnection delegate methods */ 
 
- (void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
    if (!receivedData) {
        receivedData = data;
    } else {
        receivedData += data;
    }
}
 
- (void)connection:(CPURLConnection)connection didFailWithError:(CPString)error
{
    alert("Connection did fail with error : " + error) ;
    receivedData = nil;
}
 
- (void)connectionDidFinishLoading:(CPURLConnection)aConnection
{
    [resultTextField setStringValue:receivedData];
}

@end
