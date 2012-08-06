//
//  ViewController.m
//  Url
//
//  Created by Lion User on 08/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "StringHelper.h"
#import "HTMLNode.h"
#import "HTMLParser.h"

#define add(A,B)    [(A) stringByAppendingString:(B)]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	    // Do any additional setup after loading the view from its nib.
    NSString *htmlBeginString = [[NSMutableString alloc] initWithString:@"<!DOCTYPE html><html><head><script type=\"text/javascript\" src=\"diary.js\"></script></head><body><div class=\"myclass\">Header</div><Script Language=\"JavaScript\">function sayHello(){alert(\"oioi\");} </Script><INPUT type=\"button\" value=\"Click Me\" name=\"button1\" onclick=\"javascript:sayHello();\">"];
    NSString *htmlEndString = [[NSMutableString alloc] initWithString:@"</body></html>"];
    //if (jQuery) { alert(\"jQuery loaded\");} else {alert(\"tupo\"); }
    //<script type=\"text/javascript\" src=\"jquery-1.7.2.min.js\"></script>
    //NSString * resultHtmlString;
    //resultHtmlString = add(add(htmlBeginString,resultString),htmlEndString);
    
    [webView loadHTMLString:add(htmlBeginString,htmlEndString) baseURL:nil];// Do any additional 
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
                [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://khkh.diary.ru"] 
                                     cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                     timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *html = [[NSString alloc] initWithBytes: [response bytes] length:[response length] encoding:NSWindowsCP1251StringEncoding];

//find a title

    
    NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    
    HTMLNode *headNode = [parser head];
    
    NSArray *titleNodes = [headNode findChildTags:@"link"]; 
    
    for (HTMLNode *inputNode in titleNodes) {
        if ([[inputNode getAttributeNamed:@"type"] isEqualToString:@"application/rss+xml"]) {
            [label setText:[inputNode getAttributeNamed:@"title"]]; //Answer to first question
        }
    }


    
//take posts
    
    HTMLNode *bodyNode = [parser body];
    NSArray *postNodes = [bodyNode findChildrenOfClass:@"paragraph"];
    
    //simplify each post
    NSString *resultString = [[NSString alloc] init];
    StringHelper *helper = [[StringHelper alloc] init];
    for (HTMLNode * postNode in postNodes){
        //find images in post
        NSString * rawPost = [postNode rawContents];
        NSRegularExpression* regexToUse = [[NSRegularExpression alloc] 
                                           initWithPattern:@"<img.*>"
                                           options:NSRegularExpressionCaseInsensitive 
                                           error:nil];
        NSArray* foundInText = [regexToUse matchesInString:rawPost options:0 range:NSMakeRange(0, [rawPost length])];
        if (foundInText.count>0){
        NSString* rawPostCopy = [rawPost copy];

            //divide post text in parts before and after images and add parts to one array 
            NSMutableArray *textPartsBetweenImages = [[NSMutableArray alloc] initWithCapacity:100];
            int i=0;
            //fill the array
        for (NSTextCheckingResult* b in foundInText)
        {
            
            if (i==0){
                NSString *tempstring = [rawPostCopy substringToIndex:b.range.location];
                [textPartsBetweenImages addObject:tempstring];
                if (foundInText.count>1){
                    i++;
                    continue;
                }
            }
            if (i==foundInText.count-1){
                [textPartsBetweenImages addObject:[rawPostCopy substringFromIndex:b.range.location+b.range.length]];
                i++;
                continue;
            }
            NSTextCheckingResult* previousResult = [foundInText objectAtIndex:i-1];
            NSUInteger endOfPreviousPart = previousResult.range.location+previousResult.range.length;
            NSUInteger startOfNextPart = rawPostCopy.length - endOfPreviousPart;
            [textPartsBetweenImages addObject:[rawPostCopy substringWithRange:NSMakeRange(endOfPreviousPart, startOfNextPart)]];
            i++;
        }
            //add elements of array to the output string
            i=1;
            for (NSString * part in textPartsBetweenImages){
                NSString * tempik = [NSString stringWithFormat:@"...img %d...",i];
                resultString = add(add(resultString,[helper clearString:part]),tempik);
            }
            resultString = add(resultString, @"\r\n---------------------------\r\n");
                }
        else {
            resultString = add(add(resultString, [helper clearString:rawPost]),@"\r\n---------------------------\r\n");
        }
            }
    [textView setText:resultString];

    //adding javascript
    //NSString *jqueryCDN = @"http://code.jquery.com/mobile/1.1.1/jquery.mobile-1.1.1.min.js";
   //NSData *jquery = [NSData dataWithContentsOfURL:[NSURL URLWithString:jqueryCDN]];
    //NSString *jqueryString = [[NSMutableString alloc] initWithData:jquery encoding:NSUTF8StringEncoding];
    /*NSString *filePath = [[NSBundle mainBundle] pathForResource:@"jquery-1.7.2.min" ofType:@"js" inDirectory:@""];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
                          
    filePath = [[NSBundle mainBundle] pathForResource:@"diary" ofType:@"js" inDirectory:@""];
    fileData = [NSData dataWithContentsOfFile:filePath];
    jsString = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    
    [webView stringByEvaluatingJavaScriptFromString:jsString];*/
    
    //adding html
    NSString *htmlBeginString = [[NSMutableString alloc] initWithString:@"<!DOCTYPE html><html><head></head><script type=\"text/javascript\" src=\"jquery-1.7.2.min.js\"></script><body><div class=\"myclass\">Header</div><Script Language=\"JavaScript\">function sayHello(){$('.myclass').prepend('<p>Test</p>');}</Script><INPUT type=\"button\" value=\"Click Me\" name=\"button1\" onclick=\"javascript:sayHello();\">"];
    NSString *htmlEndString = [[NSMutableString alloc] initWithString:@"</body></html>"];
    
    //NSString * resultHtmlString;
    //resultHtmlString = add(add(htmlBeginString,resultString),htmlEndString);
    
    [webView loadHTMLString:add(htmlBeginString,htmlEndString) baseURL:nil];// Do any additional setup after loading the view, typically from a nib.
//[webView stringByEvaluatingJavaScriptFromString:@"sayHello()"];
    }



@end
