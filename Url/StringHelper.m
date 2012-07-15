//
//  StringHelper.m
//  Url
//
//  Created by Lion User on 08/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StringHelper.h"

@implementation StringHelper

- (NSString*)regexReplace:(NSString*)input :(NSString*)regex :(NSString*)withString {
    
    NSRegularExpression* regexToUse = [[NSRegularExpression alloc] 
                                       initWithPattern:regex 
                                       options:NSRegularExpressionCaseInsensitive 
                                       error:nil];
    NSArray* foundInText = [regexToUse matchesInString:input options:0 range:NSMakeRange(0, [input length])];
    
    NSString* inputCopy = [input copy];
    
    for (NSTextCheckingResult* b in foundInText)
    {
        NSString* textToDelete = [input substringWithRange:b.range];
        NSString* finalString;
        
        finalString = [inputCopy stringByReplacingOccurrencesOfString:textToDelete withString:withString];
        inputCopy = finalString; 
    }
    
    return inputCopy;

}

- (NSString*)clearString:(NSString *)input{
    return [self regexReplace:[self regexReplace:[self regexReplace:input  :@"<br.?>" :@"\n"] 
                                              :@"<.*?>[\\s]*" :@""]
                      :@"&nbsp;" :@" "] ;
     //stringByAppendingString:@"\r\n---------------------------\r\n"
     
}
@end
