//
//  FDQueryCityOperation.m
//  FirstDemo
//
//  Created by mxl on 16/12/16.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDQueryCityOperation.h"
#import "NSString+Util.h"
#import "FDCity.h"

@interface FDQueryCityOperation ()

@property (nonatomic, strong) NSString *text;
@property (nonatomic, copy) void (^resultBlock)(NSArray *);

@end

@implementation FDQueryCityOperation

- (instancetype)initWithKey:(NSString *)key complectionWithResultBlock:(void (^)(NSArray *results))block {
    self = [super init];
    if (self) {
        _text = key;
        _resultBlock = block;
    }
    return self;
}

- (void)main {
    
    if (self.isCancelled) {
        return;
    }
    
    NSMutableArray *results = [NSMutableArray array];
    NSArray *provinces = [NSArray arrayWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"province.xml"]];
    NSDictionary *cities = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"city.xml"]];
    NSDictionary *counties = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"county.xml"]];
    
    if ([_text isAllEngNumAndSpecialSign]) {
        _text = _text.lowercaseString;
    }
    
    if (self.cancelled) {
        return;
    }
    // 找到包含这个字的省份的所有城市
    for (NSDictionary *province in provinces) {
        NSString *provinceName = province[@"name"];
        NSString *pinyin = province[@"pinyin"];
        
        if ([provinceName isEqualToString:@"自动定位"]) {
            continue;
        }
        
        // 如果全是英文字符
        if ([_text isAllEngNumAndSpecialSign]) {
            NSString *tempProvinceName = [pinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            // 如果是以这个字符串开头
            if ([tempProvinceName hasPrefix:_text]) {
                NSString *provinceId = province[@"id"];
                
                // 忽略直辖市
                if ([provinceId isEqualToString:@"01"] ||
                    [provinceId isEqualToString:@"02"] ||
                    [provinceId isEqualToString:@"03"] ||
                    [provinceId isEqualToString:@"04"]) {
                    break;
                }
                
                for (NSDictionary *city in cities[provinceId]) {
                    NSString *cityCode = [NSString stringWithFormat:@"101%@01", city[@"id"]];
                    FDCity *model = [[FDCity alloc] initWithCityName:city[@"name"] cityCode:cityCode];
                    [results addObject:model];
                }
            } else { // 如果字符串和拼音的首字母相同
                
                BOOL find = NO;
                
                NSArray *pinyins = [pinyin componentsSeparatedByString:@" "];
                
                if (!(_text.length > pinyins.count)) {
                    for (int i = 0; i < pinyins.count; i++) {
                        if (_text.length <= i) {
                            break;
                        } else {
                            if ([[pinyins[i] substringToIndex:1] isEqualToString:[_text substringWithRange:NSMakeRange(i, 1)]]) {
                                find = YES;
                            } else {
                                find = NO;
                                break;
                            }
                        }
                    }
                }
                
                if (find) {
                    NSString *provinceId = province[@"id"];
                    
                    if ([provinceId isEqualToString:@"01"] ||
                        [provinceId isEqualToString:@"02"] ||
                        [provinceId isEqualToString:@"03"] ||
                        [provinceId isEqualToString:@"04"]) {
                        break;
                    }
                    
                    for (NSDictionary *city in cities[provinceId]) {
                        NSString *cityCode = [NSString stringWithFormat:@"101%@01", city[@"id"]];
                        FDCity *model = [[FDCity alloc] initWithCityName:city[@"name"] cityCode:cityCode];
                        [results addObject:model];
                    }
                }
            }
        } else {
            if ([provinceName containsString:_text]) {
                NSString *provinceId = province[@"id"];
                
                if ([provinceId isEqualToString:@"01"] ||
                    [provinceId isEqualToString:@"02"] ||
                    [provinceId isEqualToString:@"03"] ||
                    [provinceId isEqualToString:@"04"]) {
                    break;
                }
                
                for (NSDictionary *city in cities[provinceId]) {
                    NSString *cityCode = [NSString stringWithFormat:@"101%@01", city[@"id"]];
                    FDCity *model = [[FDCity alloc] initWithCityName:city[@"name"] cityCode:cityCode];
                    [results addObject:model];
                }
            }
        }
    }
    
    if (self.cancelled) {
        return;
    }
    // 找到包含这个字的所有区
    for (NSArray *tempCountries in counties.allValues) {
        for (NSDictionary *country in tempCountries) {
            NSString *countryName = country[@"name"];
            NSString *pinyin = country[@"pinyin"];
            
            if ([countryName isEqualToString:@"自动定位"]) {
                continue;
            }
            
            // 如果全是英文字符
            if ([_text isAllEngNumAndSpecialSign]) {
                NSString *tempCountryName = [pinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                // 如果是以这个字符串开头
                if ([tempCountryName hasPrefix:_text]) {
                    FDCity *model = [[FDCity alloc] initWithCityName:country[@"name"] cityCode:country[@"id"]];
                    [results addObject:model];
                } else { // 如果字符串和拼音的首字母相同
                    
                    BOOL find = NO;
                    
                    NSArray *pinyins = [pinyin componentsSeparatedByString:@" "];
                    
                    if (!(_text.length > pinyins.count)) {
                        for (int i = 0; i < pinyins.count; i++) {
                            if (_text.length <= i) {
                                break;
                            } else {
                                if ([[pinyins[i] substringToIndex:1] isEqualToString:[_text substringWithRange:NSMakeRange(i, 1)]]) {
                                    find = YES;
                                } else {
                                    find = NO;
                                    break;
                                }
                            }
                        }
                    }
                    
                    if (find) {
                        FDCity *model = [[FDCity alloc] initWithCityName:country[@"name"] cityCode:country[@"id"]];
                        [results addObject:model];
                    }
                }
            } else {
                if ([countryName containsString:_text]) {
                    FDCity *model = [[FDCity alloc] initWithCityName:country[@"name"] cityCode:country[@"id"]];
                    [results addObject:model];
                }
            }
        }
    }
    
    if (self.isCancelled) {
        return;
    }
    
    self.resultBlock([results copy]);
}

@end
