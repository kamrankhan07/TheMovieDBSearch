//
//  TMDBMovieMetaData.h
//  TheMovieDBSearch
//
//  Created by Kamran Khan on 26/06/2015.
//  Copyright (c) 2015 Kamran Khan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMDBMovieMetaData : NSObject

@property (nonatomic, assign) int id;
@property (nonatomic, assign) int adult;
@property (nonatomic, copy) NSString *backdrop_path;
@property (nonatomic, strong) NSArray *genre_ids;
@property (nonatomic, copy) NSString *original_language;
@property (nonatomic, copy) NSString *original_title;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *overview;
@property (nonatomic, assign) float popularity;
@property (nonatomic, copy) NSString *poster_path;
@property (nonatomic, copy) NSString *release_date;
@property (nonatomic, assign) int video;
@property (nonatomic, assign) float vote_average;
@property (nonatomic, assign) int vote_count;

-(id) initWithData:(NSDictionary *)dict;
-(void) parseAndFillData:(NSDictionary *)dict;

@end



