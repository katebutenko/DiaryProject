//
//  StringHelper.h
//  Url
//
//  Created by Lion User on 08/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringHelper : NSObject
- (NSString*)regexReplace:(NSString*)input :(NSString*)regex :(NSString*) withString;
@end
