


//
//  FDUtils.m
//  FirstDemo
//
//  Created by mxl on 16/12/3.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDUtils.h"
#import "NSString+Util.h"

@implementation FDUtils

+ (NSString *)weatherType:(WeatherType)type {
    switch (type) {
        case 0:
            return @"晴";
            break;
        case 1:
            return @"多云";
            break;
        case 2:
            return @"阴";
            break;
        case 4:
            return @"雷雨";
            break;
        case 5:
            return @"雷雨+冰雹";
            break;
        case 7:
            return @"小雨";
            break;
        case 8:
            return @"中雨";
            break;
        case 10:
            return @"大雨";
            break;
        case 14:
            return @"下雪";
            break;
        case 18:
            return @"雾";
            break;
        case 19:
            return @"冻雨";
            break;
        case 20:
            return @"沙尘";
            break;
        case 29:
            return @"飓风";
            break;
        case 30:
            return @"霾";
            break;
        case 9999:
            return @"--";
            break;
        default:
            break;
    }
}

+ (NSString *)windDirection:(WindDirection)type {
    switch (type) {
        case 1:
            return @"北风";
            break;
        case 2:
            return @"东北风";
            break;
        case 3:
            return @"东风";
            break;
        case 4:
            return @"东南分";
            break;
        case 5:
            return @"南风";
            break;
        case 6:
            return @"西南风";
            break;
        case 7:
            return @"西风";
            break;
        case 8:
            return @"西北风";
            break;
        case 9:
            return @"无风";
            break;
        case 10:
            return @"微风";
            break;
        default:
            break;
    }
}

+ (NSString *)tempWithNumber:(NSNumber *)number {
    return [NSString stringWithFormat:@"%@°", number];
}

+ (NSString *)weakdayWithDate:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:date];
    
    switch (comp.weekday) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
        default:
            break;
    }
    
    return @"";
}

+ (NSString *)dateWithString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    [dateFormatter setDateFormat:@"MM/dd"];
    return [dateFormatter stringFromDate:date];;
}

+ (NSNumber *)hourOfTime:(NSString *)s {
    if ([s characterAtIndex:0] == '0') {
        return [NSNumber numberWithChar:[s substringWithRange:NSMakeRange(1, 1)].integerValue];
    } else {
        return [NSNumber numberWithInteger:[s substringToIndex:2].integerValue];
    }
}

+ (NSArray<FDCity *> *)getAllSeletedCities {
    NSString *home = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [home stringByAppendingString:@"/cities.plist"];
    
    NSArray *cities = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    return cities;
}

+ (void)saveAllSeletedCities:(NSArray<FDCity *> *)cities {
    NSString *home = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [home stringByAppendingString:@"/cities.plist"];
    
    [NSKeyedArchiver archiveRootObject:cities toFile:filePath];
}

+ (void)fetchDataWithCityCode:(NSString *)cityCode completionBlock:(void (^)(NSDictionary *weatherData))block {
    
    NSString *urlString1 = @"http://192.168.1.110:5001/CttApi/GetWeatherDetail?tkn=6480F2A608958030D190E9E62590174A&cid=Youloft_IOS&av=4.4.2&mac=00:11:22:33:44:55&did=b622c089e7e14d2c2fa8c9129dafbb51&chn=wnl_anzhi&cc=CN&lang=zh&bd=com.youloft.calendar&t=1430366273&cver=6.0&lasttimestamp=&model=iphone&cardId=78&";
    NSString *urlString2 = [NSString stringWithFormat:@"citycode=%@", cityCode];
    NSString *urlString3 = @"&sign=66069614e98aba9d07b1ad26d94e2450";
    
    
    NSURL *url = [NSURL URLWithString:[[urlString1 stringByAppendingString:urlString2] stringByAppendingString:urlString3]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *weatherData = dic[@"data"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // reload data
            block(weatherData);
        });
        
    }];
    
    [task resume];
}

+ (NSString *)provinceOfCity:(FDCity *)city {
    NSString *cityCode = city.cityCode;
    
    NSString *provinceId = [cityCode substringWithRange:NSMakeRange(3, 2)];
    
    NSArray *provinces = [NSArray arrayWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"province.xml"]];
    
    NSString *provinceName = @"";
    
    for (NSDictionary *province in provinces) {
        if ([province[@"id"] isEqualToString:provinceId]) {
            provinceName = province[@"name"];
        }
    }
    
    return provinceName;
}

+ (NSString *)codeOfCity:(NSString *)cityName {
    NSDictionary *counties = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"county.xml"]];
    
    for (NSArray *tempCountries in counties.allValues) {
        for (NSDictionary *country in tempCountries) {
            NSString *countryName = country[@"name"];
            if ([countryName isEqualToString:cityName]) {
                return country[@"id"];
            }
        }
    }
    
    return @"";
}

@end

//+ (void)toPinyin {
//    NSArray *provinces = [NSArray arrayWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"province.xml"]];
//    NSDictionary *cities = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"city.xml"]];
//    NSDictionary *counties = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"county.xml"]];
//    
//    NSMutableDictionary *result = [counties mutableCopy];
//    
//    // city
//    NSArray *keys = cities.allKeys;
//    NSArray *values = cities.allValues;
//    
//    for (int i = 0; i < keys.count; i++) {
//        NSArray *tempCities = values[i];
//        
//        NSMutableArray *tempArr = [NSMutableArray array];
//        for (NSDictionary *city in tempCities) {
//            NSMutableDictionary *copy = [city mutableCopy];
//            NSString *cityName = city[@"name"];
//            [copy addEntriesFromDictionary:@{@"pinyin": [cityName toPinyin]}];
//            [tempArr addObject:copy];
//        }
//        
//        result[keys[i]] = [tempArr copy];
//    }
//    
//    NSArray *keys = counties.allKeys;
//    NSArray *values = counties.allValues;
//    
//    for (int i = 0; i < keys.count; i++) {
//        NSArray *tempCounties = values[i];
//        
//        NSMutableArray *tempArr = [NSMutableArray array];
//        for (NSDictionary *county in tempCounties) {
//            NSMutableDictionary *copy = [county mutableCopy];
//            NSString *countyName = county[@"name"];
//            [copy addEntriesFromDictionary:@{@"pinyin": [countyName toPinyin]}];
//            [tempArr addObject:copy];
//        }
//        
//        result[keys[i]] = [tempArr copy];
//    }
//    
//    [result writeToFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"test.xml"] atomically:YES];
//    
//    NSLog(@"%@", [[NSBundle mainBundle] bundlePath]);
//}
