//
//  QEDTextView.m
//  CYRTextViewExample
//
//  Created by Illya Busigin on 1/10/14.
//  Copyright (c) 2014 Cyrillian, Inc. All rights reserved.
//

#import "QEDTextView.h"
#import "ColorPalette.h"

#import <CoreText/CoreText.h>

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

@implementation QEDTextView

#pragma mark - Initialization & Setup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self commonSetup];
    }
    
    return self;
}

- (void)commonSetup
{
    _defaultFont = [UIFont systemFontOfSize:14.0f];
    _boldFont = [UIFont boldSystemFontOfSize:14.0f];
    _italicFont = [UIFont fontWithName:@"HelveticaNeue-Oblique" size:14.0f];
    
    self.font = _defaultFont;
    self.textColor = [UIColor blackColor];
    
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(defaultFont)) options:NSKeyValueObservingOptionNew context:0];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(boldFont)) options:NSKeyValueObservingOptionNew context:0];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(italicFont)) options:NSKeyValueObservingOptionNew context:0];
    
    if (_italicFont == nil && ([UIFontDescriptor class] != nil))
    {
        // This works around a bug in 7.0.3 where HelveticaNeue-Italic is not present as a UIFont option
        _italicFont = (__bridge_transfer UIFont*)CTFontCreateWithName(CFSTR("HelveticaNeue-Italic"), 14.0f, NULL);
    }
    
    _nightMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"NightMode"];
    
    if (_nightMode == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"NightMode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _nightMode = @"false";
    }
    
    self.tokens = [self solverTokens];
}


- (NSArray *)solverTokens
{
    if ([_nightMode isEqualToString:@"false"]) {
        NSArray *solverTokens =  @[
                                   [CYRToken tokenWithName:@"string"
                                                expression:@"\".*?(\"|$)|“.*?(”|$)"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : ColorPalette.codeStringsColor
                                                             }],
                                   [CYRToken tokenWithName:@"reserved_words"
                                                expression:@"(corgiRun|corgi|for|in|by|case|func|else|var|return|while|write)"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : ColorPalette.codeReservedWordsColor,
                                                             NSFontAttributeName : self.boldFont
                                                             }],
                                   [CYRToken tokenWithName:@"types"
                                                expression:@"(Int|Float|Bool|Void|String)"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : ColorPalette.codeTypesColor,
                                                             NSFontAttributeName : self.boldFont
                                                             }],
                                   [CYRToken tokenWithName:@"comment"
                                                expression:@"//.*"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : ColorPalette.codeCommentsColor,
                                                             NSFontAttributeName : self.italicFont
                                                             }]];
        return solverTokens;
    } else {
        NSArray *solverTokens =  @[
                                   [CYRToken tokenWithName:@"string"
                                                expression:@"\".*?(\"|$)|“.*?(”|$)"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : ColorPalette.codeStringsColor,
                                                             NSFontAttributeName : self.boldFont
                                                             }],
                                   [CYRToken tokenWithName:@"reserved_words"
                                                expression:@"(corgiRun|corgi|for|in|by|case|func|else|var|return|while|write)"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : ColorPalette.codeReservedWordsNightModeColor,
                                                             NSFontAttributeName : self.boldFont
                                                             }],
                                   [CYRToken tokenWithName:@"types"
                                                expression:@"(Int|Float|Bool|Void|String)"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : ColorPalette.codeTypesNightModeColor,
                                                             NSFontAttributeName : self.boldFont
                                                             }],
                                   [CYRToken tokenWithName:@"comment"
                                                expression:@"//.*"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : ColorPalette.codeCommentsColor,
                                                             NSFontAttributeName : self.italicFont
                                                             }]];
        return solverTokens;
    }
    
    
}

- (void) changedMode {
    self.tokens = [self solverTokens];
}


#pragma mark - Cleanup

- (void)dealloc
{
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(defaultFont))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(boldFont))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(italicFont))];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(defaultFont))] ||
        [keyPath isEqualToString:NSStringFromSelector(@selector(boldFont))] ||
        [keyPath isEqualToString:NSStringFromSelector(@selector(italicFont))])
    {
        // Reset the tokens, this will clear any existing formatting
        self.tokens = [self solverTokens];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - Overrides

- (void)setDefaultFont:(UIFont *)defaultFont
{
    _defaultFont = defaultFont;
    self.font = defaultFont;
}

@end
