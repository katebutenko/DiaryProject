//
//  TouchableImageView.m
//  DiaryProject
//
//  Created by Екатерина Бутенко on 15.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TouchableImageView.h"

@implementation TouchableImageView

@synthesize delegate;
@synthesize imageUrl;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan!!! ");
    
    NSData * imageData = [NSData dataWithContentsOfURL:imageUrl];
    UIImage * imageToSet = [UIImage imageWithData:imageData];
    self.image = imageToSet;
    if ( delegate != nil && [delegate respondsToSelector:@selector(didTouchView:)] ) {
        [delegate didTouchView:self];
    } 
    [super touchesBegan:touches withEvent:event];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithFrameAndImageUrl :(CGRect)frame :(NSURL *)url
{
    self = [super initWithFrame:frame];
    
    if (self) {
        imageUrl = url;
    }
    return self;
}
- (id)initWithImageUrl :(NSURL *)url
{
    self = [super init];
    
    if (self) {
        imageUrl = url;
        NSData * imageData = [NSData dataWithContentsOfURL:imageUrl];
        UIImage * imageToSet = [UIImage imageWithData:imageData];
        self.image = imageToSet;

    }
    return self;
}
@end

