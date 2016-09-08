//
//  MovieSearchTableViewCell.h
//  TheMovieDBSearch
//
//  Created by Kamran Khan on 25/06/2015.
//  Copyright (c) 2015 Kamran Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXRatingView.h"

@interface MovieSearchTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *moviePoster;
@property (nonatomic, weak) IBOutlet UILabel *movieTitle;
@property (nonatomic, weak) IBOutlet UILabel *movieDescription;
@property (nonatomic, weak) IBOutlet AXRatingView *ratingView;

@end
