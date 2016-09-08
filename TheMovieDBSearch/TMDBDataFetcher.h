//
//  TMDBDataFetcher.h
//  TheMovieDBSearch
//
//  Created by Kamran Khan on 24/06/2015.
//  Copyright (c) 2015 Kamran Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMDBDataFetcher.h"
#import "TMDBMovieMetaData.h"
#import "TMDBMovieDetailedData.h"

@class TMDBDataFetcher;

@protocol TMDBDataFetcherDelegate <NSObject>
@optional
-(void) tmdbDataFetcher:(TMDBDataFetcher *)dataFetcher didExtractData:(NSArray *)dataArray forPageNo:(int)pageNo withMaxAvailablePages:(int)totalAvailablePages;
-(void) tmdbDataFetcher:(TMDBDataFetcher *)dataFetcher didExtractMovieDetails:(TMDBMovieDetailedData *)detailedData;
-(void) tmdbDataFetcher:(TMDBDataFetcher *)dataFetcher failedToExtractDataWithError:(NSError *)error;
@end

@interface TMDBDataFetcher : NSObject

@property (nonatomic, assign) id <TMDBDataFetcherDelegate> delegate;
@property (nonatomic, assign) int tag;

-(void) searchTMDBForQuery:(NSString *)query withPageNo:(int)pageNo;
-(void) cancelSearchRequest;
-(void) getMovieDetailsForId:(int)movieId;
-(void) getAndSaveConfigurationData:(void (^)(BOOL success))block;
-(void) getImageFromPath:(NSString *)posterPath withSize:(int)imgSize withBlock:(void (^)(NSString *imagePath))block;

@end
