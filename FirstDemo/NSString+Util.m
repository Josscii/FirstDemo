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
    BOOL flag = YES;
    for (int i = 0; i < self.length; i++) {
        if ([self characterAtIndex:i] < 0 || [self characterAtIndex:i] > 177) {
            flag = NO;
        }
    }
    return flag;
}

@end
