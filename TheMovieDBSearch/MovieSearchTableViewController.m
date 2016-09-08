//
//  MovieSearchTableViewController.m
//  TheMovieDBSearch
//
//  Created by Kamran Khan on 25/06/2015.
//  Copyright (c) 2015 Kamran Khan. All rights reserved.
//

#import "MovieSearchTableViewController.h"
#import "MovieSearchTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "TMDBMovieMetaData.h"
#import "MovieDetailsViewController.h"
#import "MovieSearchLoadingTableViewCell.h"

@implementation MovieSearchTableViewController

@synthesize searchBar;
@synthesize moviesDataFetcher;
@synthesize moviesDataArray;

#pragma mark - Table view data source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.moviesDataArray count] == 0) {
        return (self.searchBar.text.length > 0 && !isSearching) ? 1 : 0;
    }
    
    return [self.moviesDataArray count] + ([self isLastPage] ? 0 : 1);
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.moviesDataArray count] == 0){
        return 50;
    }
    if(indexPath.row == [self.moviesDataArray count] && ![self isLastPage]) {
        return 50;
    }
    return 100;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.moviesDataArray count] == 0)
    {
        static NSString *cellIdentifier = @"MovieSearchLoadingTableViewCell";
        MovieSearchLoadingTableViewCell *cell = (MovieSearchLoadingTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            cell = [[MovieSearchLoadingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.activityIndicator.hidden = YES;
        cell.errorMsgLbl.hidden = NO;
        cell.errorMsgLbl.text = @"No results found for searched term";
        return cell;
    }
    else if(indexPath.row == [self.moviesDataArray count] && ![self isLastPage])
    {
        static NSString *cellIdentifier = @"MovieSearchLoadingTableViewCell";
        MovieSearchLoadingTableViewCell *cell = (MovieSearchLoadingTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            cell = [[MovieSearchLoadingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.activityIndicator.hidden = NO;
        cell.errorMsgLbl.hidden = YES;
        [cell.activityIndicator startAnimating];
        return cell;
    }
    
    static NSString *cellIdentifier = @"MovieSearchTableViewCell";
    MovieSearchTableViewCell *cell = (MovieSearchTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[MovieSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    TMDBMovieMetaData *metaData = self.moviesDataArray[indexPath.row];
    
    cell.movieTitle.text = metaData.title;
    cell.movieDescription.text = metaData.overview;
    cell.ratingView.value = metaData.popularity;
    
    if(showPosters && (metaData.poster_path.length > 0))
    {
        [self.moviesDataFetcher getImageFromPath:metaData.poster_path withSize:PosterSize_w92 withBlock:^(NSString *imagePath) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [cell.moviePoster sd_setImageWithURL:[NSURL URLWithString:imagePath]
                                    placeholderImage:[UIImage imageNamed:@"placeholder-small"]];
                
            });
        }];
    }
    else
    {
        cell.moviePoster.image = [UIImage imageNamed:@"placeholder-small"];
    }
    
    return cell;
}

#pragma mark - Paging Mechanism

-(BOOL) isLastPage
{
    return (currentPage == totalPages);
}

-(void) loadNextPage
{
    if(loadingNextPage == NO)
    {
        self.moviesDataFetcher.delegate = nil;
        loadingNextPage = YES;
    
        self.moviesDataFetcher = [[TMDBDataFetcher alloc] init];
        self.moviesDataFetcher.delegate = self;
        [self.moviesDataFetcher searchTMDBForQuery:self.searchBar.text withPageNo:(currentPage+1)];
    }
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.moviesDataArray.count == 0) {
        return;
    }
    
    if(indexPath.row == [self.moviesDataArray count] && ![self isLastPage]) //Load Next Page
    {
        [self loadNextPage];
    }
}

#pragma mark - TMDBDataFetcherDelegate

-(void) tmdbDataFetcher:(TMDBDataFetcher *)dataFetcher didExtractData:(NSArray *)dataArray forPageNo:(int)pageNo withMaxAvailablePages:(int)totalAvailablePages
{
    currentPage = pageNo;
    loadingNextPage = NO;
    loadingRetryCount = 0;
    isSearching = NO;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    totalPages = totalAvailablePages;
    
    [self.moviesDataArray addObjectsFromArray:dataArray];
    [self.tableView reloadData];
}

-(void) tmdbDataFetcher:(TMDBDataFetcher *)dataFetcher failedToExtractDataWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error description]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if(loadingNextPage && (loadingRetryCount <= NextPageReloadingMaxTryCount))
    {
        loadingRetryCount++;
        loadingNextPage = NO;
        [self loadNextPage];
    }
    else
    {
        //Stop Activity Indicator
        @try {
            NSArray *arr = [self.tableView visibleCells];
            UITableViewCell *cell = [arr lastObject];
            if(cell && [cell isKindOfClass:[MovieSearchLoadingTableViewCell class]])
            {
                MovieSearchLoadingTableViewCell *kCell = (MovieSearchLoadingTableViewCell *)cell;
                [kCell.activityIndicator stopAnimating];
                kCell.activityIndicator.hidden = YES;
                kCell.errorMsgLbl.hidden = NO;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", [exception description]);
        }
        
        loadingNextPage = NO;
        loadingRetryCount = 0;
        isSearching = NO;
    }
}

#pragma mark - Search Display Controller

-(void) searchForKeyword:(NSString *)keyword
{
    loadingNextPage = NO;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    self.moviesDataFetcher = [[TMDBDataFetcher alloc] init];
    self.moviesDataFetcher.delegate = self;

    [self.moviesDataFetcher searchTMDBForQuery:keyword withPageNo:currentPage];
}

-(void) clearPreviousSearchResultsAndCalls
{
    //Clear previous data fetcher
    self.moviesDataFetcher.delegate = nil;
    [self.moviesDataFetcher cancelSearchRequest];
    self.moviesDataFetcher = nil;

    [self.moviesDataArray removeAllObjects];
    currentPage = 1;
    
    //Reload TableView
    [self.tableView reloadData];
    
    //Cancel Previous perform selector call, if any
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"search text: %@", searchText);
    isSearching = YES;
    
    [self clearPreviousSearchResultsAndCalls];
    
    if(searchText.length > 0)
    {
        [self performSelector:@selector(searchForKeyword:) withObject:searchText afterDelay:0.25];
    }
}

#pragma mark - Prepare Segue

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowMovieDetail"])
    {
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        
        [self.searchBar resignFirstResponder];

        MovieDetailsViewController *viewController = [segue destinationViewController];
        viewController.movieMetaData = self.moviesDataArray[selectedIndexPath.row];
    }
}

#pragma mark - View Life Cycle

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BOOL adultContentSetting = [[SettingsManager sharedInstance] getSettingValueForKey:SettingKey_ShowAdultContent];
    BOOL showPosterSetting = [[SettingsManager sharedInstance] getSettingValueForKey:SettingKey_ShowPosters];
    if(showAdultContent != adultContentSetting)
    {
        showAdultContent = adultContentSetting;
        showPosters = showPosterSetting;
        
        isSearching = YES;
        
        [self clearPreviousSearchResultsAndCalls];
        
        if(self.searchBar.text.length > 0)
        {
            [self searchForKeyword:self.searchBar.text];
        }
    }
    else if(showPosters != showPosterSetting)
    {
        showPosters = showPosterSetting;
        [self.tableView reloadData];
    }
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.scrollsToTop = YES;
    self.tableView.rowHeight = 100;
    
    showAdultContent = [[SettingsManager sharedInstance] getSettingValueForKey:SettingKey_ShowAdultContent];
    showPosters = [[SettingsManager sharedInstance] getSettingValueForKey:SettingKey_ShowPosters];
    
    self.moviesDataArray = [NSMutableArray array];
}

-(void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    //Clear Cached Data
    SDImageCache *cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
    [cache clearDisk];
}

@end





