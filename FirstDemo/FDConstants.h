//
//  FDConstants.h
//  FirstDemo
//
//  Created by mxl on 16/12/2.
//  Copyright © 2016年 tbw. All rights reserved.
//

#ifndef FDConstants_h
#define FDConstants_h

#define SFDU @"SanFranciscoDisplay-Ultralight"
#define SFDR @"SanFranciscoDisplay-Regular"
#define SFDB @"SanFranciscoDisplay-Bold"
#define PFSCR @"PingFangSC-Regular"
#define PFSCM @"PingFangSC-Medium"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define EDITINGCITY @"editingCity"
#define DEFAULTCIYTINDEX @"defaultCityIndex"
#define CURRENTCITYCOUNT @"currentCityCount"
#define LOCATION @"location"
#define SELECTEDINDEX @"selectedIndex"

typedef NS_ENUM(NSInteger, WeatherType) {
    WeatherTypeQing=0,
    WeatherTypeDuoYun,
    WeatherTypeYin,
    WeatherTypeLeiYu=4,
    WeatherTypeLeiYuBingBao,
    WeatherTypeXiaoYu=7,
    WeatherTypeZhongYu,
    WeatherTypeDaYu=10,
    WeatherTypeXiaXue=14,
    WeatherTypeWu=18,
    WeatherTypeDongYu,
    WeatherTypeShaChen,
    WeatherTypeJuFeng=29,
    WeatherTypeMai,
    WeatherTypeUnknow = 9999
};

typedef NS_ENUM(NSInteger, WindDirection) {
    WindDirectioNorth = 1,
    WindDirectionNorthEast,
    WindDirectionEast,
    WindDirectionSouthEast,
    WindDirectionSouth,
    WindDirectionSouthWest,
    WindDirectionWest,
    WindDirectionNorthWest,
    WindDirectionNone,
    WindDirectionWeiFeng
};

#endif /* FDConstants_h */
