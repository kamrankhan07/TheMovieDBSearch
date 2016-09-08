//
//  MovieSearchTableViewController.h
//  TheMovieDBSearch
//
//  Created by Kamran Khan on 25/06/2015.
//  Copyright (c) 2015 Kamran Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMDBDataFetcher.h"

@interface MovieSearchTableViewController : UITableViewController <TMDBDataFetcherDelegate>
{
    int currentPage;
    int totalPages;
    BOOL showAdultContent;
    BOOL showPosters;
    BOOL loadingNextPage;
    int loadingRetryCount;
    BOOL isSearching;
}

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) TMDBDataFetcher *moviesDataFetcher;
@property (nonatomic, strong) NSMutableArray *moviesDataArray;

@end
