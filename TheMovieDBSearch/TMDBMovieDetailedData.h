//
//  TMDBMovieDetailedData.h
//  TheMovieDBSearch
//
//  Created by Kamran Khan on 26/06/2015.
//  Copyright (c) 2015 Kamran Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMDBMovieMetaData.h"

@interface TMDBMovieDetailedData : NSObject

@property (nonatomic, strong) TMDBMovieMetaData *basicInfo;
@property (nonatomic, assign) double budget;
@property (nonatomic, assign) double revenue;
@property (nonatomic, strong) NSArray *genres;
@property (nonatomic, copy) NSString *belongs_to_collection; //check
@property (nonatomic, copy) NSString *imdb_id;
@property (nonatomic, strong) NSArray *production_companies;
@property (nonatomic, strong) NSArray *production_countries;
@property (nonatomic, strong) NSArray *spoken_languages;
@property (nonatomic, copy) NSString *tagline;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) int runtime;
@property (nonatomic, copy) NSString *homepage;

-(id) initWithData:(NSDictionary *)dict;
-(void) parseAndFillData:(NSDictionary *)dict;

@end
