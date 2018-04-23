//
//  TitleCollectionReusableView.m
//  CorgiCode
//
//  Created by Jessica M Cavazos Erhard on 4/23/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import "TitleCollectionReusableView.h"

@implementation TitleCollectionReusableView

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    _titleLabel.text = _title;
    
    return self;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
    _title = title;
}

@end
