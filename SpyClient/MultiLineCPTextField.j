@import <AppKit/CPView.j>

@implementation CPWebView(ScrollFixesForMultiLine) {
    - (void)loadHTMLStringWithoutMessingUpScrollbars:(CPString)aString
    {
        [self _startedLoading];
    
        _ignoreLoadStart = YES;
        _ignoreLoadEnd = NO;
    
        _url = null;
        _html = aString;
    
        [self _load];
    }
}
@end

@implementation MultiLineCPTextField : CPWebView
{
}

- (id)initWithFrame:(CGRect)aFrame
{
    if (self = [super initWithFrame:aFrame]) {
        var bounds = [self bounds];
        
        [self setFrameLoadDelegate:self];
        [self loadHTMLStringWithoutMessingUpScrollbars:@"<html><head></head><body style='padding:0px; margin:0px'><textarea id='multiline_textarea' style='left: 0px; top: 0px; width: 100%; height: 100%'></textarea></body></html>"];
    }

    return self;
}

- (CPString)stringValue
{
    var domWin = [self DOMWindow];
    return domWin.document.getElementById('multiline_textarea').value;
}

/* Overriding CPWebView's implementation */
- (BOOL)_resizeWebFrame {
    var width = [self bounds].size.width,
        height = [self bounds].size.width;

    _iframe.setAttribute("width", width);
    _iframe.setAttribute("height", height);

    [_frameView setFrameSize:CGSizeMake(width, height)];
}





@end


