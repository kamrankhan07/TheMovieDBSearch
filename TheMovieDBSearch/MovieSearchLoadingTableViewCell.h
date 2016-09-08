//
//  MovieSearchLoadingTableViewCell.h
//  TheMovieDBSearch
//
//  Created by Kamran Khan on 26/06/2015.
//  Copyright (c) 2015 Kamran Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieSearchLoadingTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet UILabel *errorMsgLbl;

@end
