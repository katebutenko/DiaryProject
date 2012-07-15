//
//  TouchableImageView.h
//  DiaryProject
//
//  Created by Екатерина Бутенко on 15.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchableImageView : UIImageView {
    id  delegate;
    NSURL* imageUrl;
}
@property(retain) id delegate;
@property NSURL* imageUrl;
- (id)initWithFrameAndImageUrl :(CGRect)frame :(NSURL *)url;
- (id)initWithImageUrl  :(NSURL *)url;
@end

@interface NSObject(TouchableImageView)
-(void)didTouchView:(UIView *)aView;
@end 
