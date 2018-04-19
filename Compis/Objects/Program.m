//
//  Program.m
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 4/17/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import "Program.h"

@implementation Program

- (id) initWithTitle:(NSString *)title andCode:(NSString *)code {
    self = [super init];
    
    if (self) {
        self.title = title;
        self.code = code;
    }

    return self;
}

@end
