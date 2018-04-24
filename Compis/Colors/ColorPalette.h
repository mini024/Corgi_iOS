//
//  NightModePalette.h
//  CorgiCode
//
//  Created by Jessica M Cavazos Erhard on 4/24/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorPalette : UIColor

+ (UIColor *) codeBackgroundColor;
+ (UIColor *) codeTextColor;
+ (UIColor *) codeStringsColor;
+ (UIColor *) codeReservedWordsColor;
+ (UIColor *) codeTypesColor;
+ (UIColor *) codeBackgroundNightModeColor;
+ (UIColor *) codeTextNightModeColor;
+ (UIColor *) codeReservedWordsNightModeColor;
+ (UIColor *) codeTypesNightModeColor;
+ (UIColor *) codeCommentsColor;
+ (UIColor *) outputBackgroundColor;
+ (UIColor *) outputTextColor;

@end
