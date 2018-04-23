//
//  Program.m
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 4/17/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import "Program.h"

NSString * const KEY_PROGRAM_TITLE = @"programTitle";
NSString * const KEY_PROGRAM_CODE = @"programCode";

@implementation Program

- (id)initWithTitle:(NSString *)title andCode:(NSString *)code {
    self = [super init];
    
    if (self) {
        self.title = title;
        self.code = code;
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _title = [coder decodeObjectForKey:KEY_PROGRAM_TITLE];
        _code = [coder decodeObjectForKey:KEY_PROGRAM_CODE];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    //[super encodeWithCoder:coder];
    [coder encodeObject:_title forKey:KEY_PROGRAM_TITLE];
    [coder encodeBool:_code forKey:KEY_PROGRAM_CODE];
}

- (NSString*) getCode {
    return _code;
}

- (NSString*) getTitle {
    return _title;
}


@end
