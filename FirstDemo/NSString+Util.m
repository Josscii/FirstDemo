//
//  NSString+Util.m
//  FirstDemo
//
//  Created by mxl on 16/12/16.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

- (NSString *)toPinyin {
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    BOOL isNeedTransform = ![self isAllEngNumAndSpecialSign];
    if (isNeedTransform) {
        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, false);
    }
    return mutableString;
}

- (BOOL)isAllEngNumAndSpecialSign {
    NSString *regularString = @"^[A-Za-z0-9\\p{Z}\\p{P}]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularString];
    return [predicate evaluateWithObject:self];
}

@end
