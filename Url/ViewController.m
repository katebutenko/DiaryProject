//
//  ViewController.m
//  Url
//
//  Created by Lion User on 08/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "StringHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)createRequest:(id)sender{
    NSMutableURLRequest *request = 
                [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://legeartis.diary.ru"] 
                                     cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                     timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *html = [[NSString alloc] initWithBytes: [response1 bytes] length:[response1 length] encoding:NSWindowsCP1251StringEncoding];

    //find a title
    
    NSRegularExpression* regex1 = [[NSRegularExpression alloc] 
                                   initWithPattern:@"<link[^>]*application/rss[^>]*title=\"(.*?)\""
                                   options:NSRegularExpressionCaseInsensitive 
                                   error:nil];
    NSArray* results = [regex1 matchesInString:html options:0 range:NSMakeRange(0, [html length])];
    NSTextCheckingResult *match = [regex1 firstMatchInString:html options:0 range:NSMakeRange(0, [html length])];
    NSString *title = [html substringWithRange:[match rangeAtIndex:1]];
    
    [label setText:title];
    //find all posts on the page
    
    regex1 = [[NSRegularExpression alloc] 
              initWithPattern:@"<div[^>]*postInner[^>]*>[\\s\\S]*?<div[^>]*clear[^>]*>"
              options:NSRegularExpressionCaseInsensitive
              error:nil];
    
    results = [regex1 matchesInString:html options:0 range:NSMakeRange(0, [html length])];
    
  
    NSString* contentCopy = [html copy];

    NSString *stringWithoutTags;
    NSString *stringWithoutEscapedSymbols;
    NSString *resultString = [[NSString alloc] init];
    NSString *stringWithNewlines;
    
    //simplify each post
    
    for (NSTextCheckingResult* foundElement in results)
    {
        NSString* texty = [contentCopy substringWithRange:foundElement.range];    
        StringHelper *helper = [[StringHelper alloc] init];
        
        stringWithNewlines = [helper regexReplace:texty :@"<br.?>" :@"\n"];
        stringWithoutTags = [helper regexReplace:stringWithNewlines  :@"<.*?>[\\s]*" :@""];
        stringWithoutEscapedSymbols = [helper regexReplace:stringWithoutTags :@"&nbsp;" :@" "];
        resultString = [[resultString stringByAppendingString:stringWithoutEscapedSymbols] stringByAppendingString:@"\r\n---------------------------\r\n"];
        
    }
    
    [textView setText:resultString];

}

@end
