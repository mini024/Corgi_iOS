//
//  ProgramCollectionViewCell.m
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 4/17/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import "ProgramCollectionViewCell.h"

@implementation ProgramCollectionViewCell

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    _programNameLabel.text = _programName;
    
    return self;
}

- (void)setProgramName:(NSString *)name {
    _programNameLabel.text = name;
}

@end
