//
//  MovieDetailsViewController.m
//  TheMovieDBSearch
//
//  Created by Kamran Khan on 26/06/2015.
//  Copyright (c) 2015 Kamran Khan. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "UIImageView+WebCache.h"

@implementation MovieDetailsViewController

#pragma mark - Methods

-(IBAction) openIMDBLink:(id)sender
{
    //http://www.imdb.com/title/imdb_id/
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.imdb.com/title/%@/", self.movieDetailedData.imdb_id]];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - TMDBDataFetcherDelegate

-(void) tmdbDataFetcher:(TMDBDataFetcher *)dataFetcher didExtractMovieDetails:(TMDBMovieDetailedData *)detailedData;
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    self.movieDetailedData = detailedData;
    
    //Show items with animation
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         
                         
                         if(detailedData.tagline.length > 0)
                         {
                             self.taglineLbl.hidden = NO;
                             self.taglineLbl.text = detailedData.tagline;
                         }
                         
                         if(detailedData.imdb_id.length > 0)
                         {
                             self.imdbButton.hidden = NO;
                         }
                         
                     } completion:nil];
    
    
    if(detailedData.basicInfo.release_date.length > 0)
    {
        self.statusLbl.text = [NSString stringWithFormat:@"%@ (%@)", detailedData.status, detailedData.basicInfo.release_date];
    }
    else
    {
        self.statusLbl.text = [NSString stringWithFormat:@"%@", detailedData.status];
    }
    
    int minutes = detailedData.runtime;
    if(minutes > 0)
    {
        int hour = minutes / 60;
        int min = minutes % 60;
        self.durationLbl.text = (hour == 0) ? [NSString stringWithFormat:@"Duration: %02d m", minutes] : [NSString stringWithFormat:@"Duration: %d hr %02d m", hour, min];
    }
}

-(void) tmdbDataFetcher:(TMDBDataFetcher *)dataFetcher failedToExtractDataWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error description]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - View Life Cycle

-(void) viewDidLoad
{
    [super viewDidLoad];
    //self.title = self.movieMetaData.title;
    
    //Constraints to fix scroll view issue
    //Reference article: http://spin.atomicobject.com/2014/03/05/uiscrollview-autolayout-ios/
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.0
                                                                       constant:0];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.0
                                                                        constant:0];
    [self.view addConstraint:leftConstraint];
    [self.view addConstraint:rightConstraint];
    
    //Load basic data and fetch detailed data
    showPosters = [[SettingsManager sharedInstance] getSettingValueForKey:SettingKey_ShowPosters];
    self.imdbButton.hidden = YES;
    self.titleLbl.text = @"";
    self.taglineLbl.hidden = YES;
    self.overviewTextView.text = @"";
    self.ratingView.hidden = YES;
    self.statusLbl.text = @"";
    self.durationLbl.text = @"";
    
    if(self.movieMetaData)
    {
        dataFetcher = [[TMDBDataFetcher alloc] init];
        dataFetcher.delegate = self;
        [dataFetcher getMovieDetailsForId:self.movieMetaData.id];
        
        if(showPosters && (self.movieMetaData.backdrop_path.length > 0))
        {
            [dataFetcher getImageFromPath:self.movieMetaData.backdrop_path withSize:BackdropSize_w1280 withBlock:^(NSString *imagePath) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:imagePath]
                                          placeholderImage:[UIImage imageNamed:@"BackdropPlaceholder"]];
                    
                });
            }];
        }
        else
        {
            self.posterImageView.image = [UIImage imageNamed:@"BackdropPlaceholder"];
        }
        
        
        self.titleLbl.text = self.movieMetaData.title;
        self.overviewTextView.text = self.movieMetaData.overview;
        self.ratingView.hidden = NO;
        self.ratingView.stepInterval = 0.1;
        self.ratingView.value = self.movieMetaData.popularity;
    }
}

-(void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) dealloc
{
    dataFetcher.delegate = nil;
    [dataFetcher cancelSearchRequest];
}


@end



