//
//  ViewController.h
//  Url
//
//  Created by Lion User on 08/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
IBOutlet UILabel *label;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextView *textView;
    IBOutlet UIWebView *webView;
}
- (IBAction)createRequest:(id)sender;

@end
