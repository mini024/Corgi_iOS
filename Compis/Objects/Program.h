//
//  Program.h
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 4/17/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Program : NSObject <NSCoding>

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* code;

- (id) initWithTitle:(NSString *)title andCode:(NSString *)code;
- (void) setTitle:(NSString *)title;
- (void) setCode:(NSString *)code;
- (NSString*) getTitle;
- (NSString*) getCode;

@end
