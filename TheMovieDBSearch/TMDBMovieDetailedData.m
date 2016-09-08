//
//  TMDBMovieDetailedData.m
//  TheMovieDBSearch
//
//  Created by Kamran Khan on 26/06/2015.
//  Copyright (c) 2015 Kamran Khan. All rights reserved.
//

#import "TMDBMovieDetailedData.h"

@implementation TMDBMovieDetailedData

#pragma mark - Methods

-(void) parseAndFillData:(NSDictionary *)dict
{
    @try {
        
        NSMutableDictionary *mutableDict = [dict mutableCopy];
        //Eliminate all null objects
        for(NSString *key in mutableDict.allKeys)
        {
            id object = [mutableDict objectForKey:key];
            if([object isKindOfClass:[NSNull class]])
            {
                [mutableDict setObject:@"" forKey:key];
            }
        }
        
        self.basicInfo = [[TMDBMovieMetaData alloc] initWithData:mutableDict];
        self.budget = [[mutableDict objectForKey:@"budget"] doubleValue];
        self.revenue = [[mutableDict objectForKey:@"revenue"] doubleValue];
        self.genres = [mutableDict objectForKey:@"genres"];
        self.belongs_to_collection = [mutableDict objectForKey:@"belongs_to_collection"];
        self.imdb_id = [mutableDict objectForKey:@"imdb_id"];
        self.production_companies = [mutableDict objectForKey:@"production_companies"];
        self.production_countries = [mutableDict objectForKey:@"production_countries"];
        self.spoken_languages = [mutableDict objectForKey:@"spoken_languages"];
        self.tagline = [mutableDict objectForKey:@"tagline"];
        self.status = [mutableDict objectForKey:@"status"];
        self.homepage = [mutableDict objectForKey:@"homepage"];
        self.runtime = [[mutableDict objectForKey:@"runtime"] intValue];
    }
    @catch (NSException *exception) {
        NSLog(@"Parsing Error: %@", [exception description]);
    }
}

-(id) initWithData:(NSDictionary *)dict
{
    self = [super init];
    if(self)
    {
        [self parseAndFillData:dict];
    }
    return self;
}

@end
