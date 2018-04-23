//
//  TitleCollectionReusableView.h
//  CorgiCode
//
//  Created by Jessica M Cavazos Erhard on 4/23/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) NSString *title;

- (void)setTitle:(NSString *)title;

@end
