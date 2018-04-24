//
//  NightModePalette.m
//  CorgiCode
//
//  Created by Jessica M Cavazos Erhard on 4/24/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import "ColorPalette.h"

@implementation ColorPalette

+ (UIColor *) codeBackgroundColor {
    return [[UIColor alloc] initWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0];
}

+ (UIColor *) codeBackgroundNightModeColor {
    return [[UIColor alloc] initWithRed:44.0/255.0 green:62.0/255.0 blue:90.0/255.0 alpha:1.0];
}

+ (UIColor *) codeTextColor {
    return UIColor.blackColor;
}

+ (UIColor *) codeTextNightModeColor {
    return [[UIColor alloc] initWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0];
}

+ (UIColor *) codeStringsColor {
    return [[UIColor alloc] initWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0];
}

+ (UIColor *) codeReservedWordsNightModeColor {
    return [[UIColor alloc] initWithRed:200.0/255.0 green:93.0/255.0 blue:182.0/255.0 alpha:1.0];
}

+ (UIColor *) codeReservedWordsColor {
    return [[UIColor alloc] initWithRed:200.0/255.0 green:93.0/255.0 blue:182.0/255.0 alpha:1.0];
}

+ (UIColor *) codeTypesNightModeColor {
    return [[UIColor alloc] initWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0];
}

+ (UIColor *) codeTypesColor {
    return [[UIColor alloc] initWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0];
}

+ (UIColor *) codeCommentsColor {
    return [[UIColor alloc] initWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:1.0];
}

+ (UIColor *) outputBackgroundColor {
    return [[UIColor alloc] initWithRed:52.0/255.0 green:73.0/255.0 blue:94.0/255.0 alpha:1.0];
}

+ (UIColor *) outputTextColor {
    return [[UIColor alloc] initWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0];
}

@end
