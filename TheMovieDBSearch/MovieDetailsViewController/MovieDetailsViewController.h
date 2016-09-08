//
//  MovieDetailsViewController.h
//  TheMovieDBSearch
//
//  Created by Kamran Khan on 26/06/2015.
//  Copyright (c) 2015 Kamran Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMDBMovieMetaData.h"
#import "TMDBMovieDetailedData.h"
#import "TMDBDataFetcher.h"
#import "AXRatingView.h"
#import "CustomUIScrollView.h"

@interface MovieDetailsViewController : UIViewController <TMDBDataFetcherDelegate>
{
    BOOL showPosters;
    TMDBDataFetcher *dataFetcher;
}

@property (nonatomic, strong) TMDBMovieMetaData *movieMetaData;
@property (nonatomic, strong) TMDBMovieDetailedData *movieDetailedData;
@property (nonatomic, weak) IBOutlet CustomUIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIImageView *posterImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLbl;
@property (nonatomic, weak) IBOutlet UILabel *taglineLbl;
@property (nonatomic, weak) IBOutlet UITextView *overviewTextView;
@property (nonatomic, weak) IBOutlet UIButton *imdbButton;
@property (nonatomic, weak) IBOutlet AXRatingView *ratingView;
@property (nonatomic, weak) IBOutlet UILabel *statusLbl;
@property (nonatomic, weak) IBOutlet UILabel *durationLbl;


-(IBAction) openIMDBLink:(id)sender;

@end
