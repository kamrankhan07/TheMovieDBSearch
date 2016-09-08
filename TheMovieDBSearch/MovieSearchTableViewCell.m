//
//  MovieSearchTableViewCell.m
//  TheMovieDBSearch
//
//  Created by Kamran Khan on 25/06/2015.
//  Copyright (c) 2015 Kamran Khan. All rights reserved.
//

#import "MovieSearchTableViewCell.h"

@implementation MovieSearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.ratingView.stepInterval = 0.1;
    self.ratingView.markFont = [UIFont systemFontOfSize:15.0];
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(15, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:separatorLine];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
