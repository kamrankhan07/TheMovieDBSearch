//
//  TMDBDataFetcher.m
//  TheMovieDBSearch
//
//  Created by Kamran Khan on 24/06/2015.
//  Copyright (c) 2015 Kamran Khan. All rights reserved.
//

#import "TMDBDataFetcher.h"

#define API_KEY @"ea7693d0a1104b1d3b0578fa96f3b6bd"
#define Base_URL @"https://api.themoviedb.org/3"


@interface TMDBDataFetcher ()

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@end


@implementation TMDBDataFetcher

@synthesize delegate;
@synthesize tag;

#pragma mark - Parameter String

-(NSString *) getParamStringForDictionary:(NSDictionary *)dict
{
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *allKeys = dict.allKeys;
    for(NSString *key in allKeys)
    {
        [arr addObject:[NSString stringWithFormat:@"%@=%@", key, [dict objectForKey:key]]];
    }
    return [arr componentsJoinedByString:@"&"];
}

#pragma mark - Configuration Methods

-(void) getAndSaveConfigurationData:(void (^)(BOOL success))block
{
    NSDictionary *dict = @{
                           @"api_key" : API_KEY,
                           };
    NSString *parameters = [self getParamStringForDictionary:dict];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/configuration?%@", Base_URL, parameters]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      if(!error)
                                      {
                                          NSError *parseError = nil;
                                          NSDictionary *configurationDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                          
                                          if(!parseError)
                                          {
                                              //Save fetched configuration data
                                              [[SettingsManager sharedInstance] saveConfigurationData:configurationDict];
                                              
                                              if(block)
                                              {
                                                  block(YES);
                                              }
                                          }
                                          else
                                          {
                                              NSLog(@"Error in data.");
                                             
                                              if(block)
                                              {
                                                  block(NO);
                                              }
                                          }
                                      }
                                      else
                                      {
                                          NSLog(@"Error:%@", [error description]);
                                      }
                                  }];
    //Request Data
    [task resume];
    self.dataTask = task;
}

#pragma mark - Poster Image

-(void) getImageFromPath:(NSString *)posterPath withSize:(int)imgSize withBlock:(void (^)(NSString *imagePath))block
{
    @try {
        
        NSString *posterSizeStr = PosterSizeStr(imgSize);
        
        NSDictionary *configDict = [[SettingsManager sharedInstance] getConfigurationData];
        if(!configDict)
        {
            [self getAndSaveConfigurationData:^(BOOL success) {
                if(success)
                {
                    NSDictionary *configDict = [[SettingsManager sharedInstance] getConfigurationData];
                    
                    NSString *baseUrl = [[configDict objectForKey:@"images"] objectForKey:@"base_url"];
                    NSString *imagePath = [NSString stringWithFormat:@"%@/%@%@", baseUrl, posterSizeStr, posterPath];
                    
                    if(block)
                    {
                        block(imagePath);
                    }
                    
                    return;
                }
            }];
        }
        
        //http://image.tmdb.org/t/p/w500/8uO0gUM8aNqYLs1OsTBQiXu0fEv.jpg
        NSString *baseUrl = [[configDict objectForKey:@"images"] objectForKey:@"base_url"];
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@%@", baseUrl, posterSizeStr, posterPath];
        
        if(block)
        {
            block(imagePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", [exception description]);
    }
}

#pragma mark - Detailed Data

-(void) parseMovieDetailsDataAndDelegate:(NSData *)data
{
    TMDBMovieDetailedData *detailedMovieData = nil;
    
    @try {
        
        if(data)
        {
            NSError *error = nil;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if([jsonDict objectForKey:@"status_code"])
            {
                if([[jsonDict objectForKey:@"status_code"] intValue] == 25)
                {
                    NSLog(@"Limit Exceeded!");
                }
            }
            else
            {
                detailedMovieData = [[TMDBMovieDetailedData alloc] initWithData:jsonDict];
            }
        }
        else
        {
            NSLog(@"Data is nil. Nothing much to do!");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in data parsing: %@", [exception description]);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.delegate && [self.delegate respondsToSelector:@selector(tmdbDataFetcher:didExtractMovieDetails:)])
        {
            [self.delegate tmdbDataFetcher:self didExtractMovieDetails:detailedMovieData];
        }
    });
}

-(void) getMovieDetailsForId:(int)movieId
{
    NSDictionary *dict = @{
                           @"api_key" : API_KEY
                           };
    NSString *parameters = [self getParamStringForDictionary:dict];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/movie/%d?%@", Base_URL, movieId, parameters]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      if([response isKindOfClass:[NSHTTPURLResponse class]])
                                      {
                                          NSLog(@"Response HTTP Status code: %ld\n", (long)[(NSHTTPURLResponse *)response statusCode]);
                                          NSLog(@"Response HTTP Headers:\n%@\n", [(NSHTTPURLResponse *)response allHeaderFields]);
                                      }
                                      
                                      if(error)
                                      {
                                          NSLog(@"Error:%@", [error description]);
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              //Delegate Error response
                                              if(self.delegate && [self.delegate respondsToSelector:@selector(tmdbDataFetcher:failedToExtractDataWithError:)])
                                              {
                                                  [self.delegate tmdbDataFetcher:self failedToExtractDataWithError:error];
                                              }
                                          });
                                      }
                                      else
                                      {
                                          [self parseMovieDetailsDataAndDelegate:data];
                                      }
                                  }];
    
    //Request Data
    [task resume];
    self.dataTask = task;
}

#pragma mark - Search Methods

-(void) parseDataAndDelegate:(NSData *)data
{
    NSMutableArray *array = [NSMutableArray array];
    int pageNo = 1;
    int maxPages = 1;
    
    @try {
        
        if(data)
        {
            NSError *error = nil;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if([jsonDict objectForKey:@"status_code"])
            {
                if([[jsonDict objectForKey:@"status_code"] intValue] == 25)
                {
                    NSLog(@"Limit Exceeded!");
                }
            }
            else
            {
                NSArray *allResults = [jsonDict objectForKey:@"results"];
                pageNo   = [[jsonDict objectForKey:@"page"] intValue];
                maxPages = [[jsonDict objectForKey:@"total_pages"] intValue];
                
                for(NSDictionary *dict in allResults)
                {
                    TMDBMovieMetaData *metaData = [[TMDBMovieMetaData alloc] initWithData:dict];
                    [array addObject:metaData];
                }
            }
        }
        else
        {
            NSLog(@"Data is nil. Nothing much to do!");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in data parsing: %@", [exception description]);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.delegate && [self.delegate respondsToSelector:@selector(tmdbDataFetcher:didExtractData:forPageNo:withMaxAvailablePages:)])
        {
            [self.delegate tmdbDataFetcher:self didExtractData:array forPageNo:pageNo withMaxAvailablePages:maxPages];
        }
    });
}

-(void) searchTMDBForQuery:(NSString *)query withPageNo:(int)pageNo
{
    BOOL adultContentSetting = [[SettingsManager sharedInstance] getSettingValueForKey:SettingKey_ShowAdultContent];
    NSString *adultContentSettingStr = adultContentSetting ? @"true" : @"false";
    
    NSDictionary *dict = @{
                           @"api_key" : API_KEY,
                           @"search_type": @"ngram", //Search Type set to autocomplete
                           @"query" : [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], //Movie to search
                           @"include_adult" : adultContentSettingStr,
                           @"page" : @(pageNo) //Result Page no
                           };
    NSString *parameters = [self getParamStringForDictionary:dict];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/search/movie?%@", Base_URL, parameters]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                    
                                      if([response isKindOfClass:[NSHTTPURLResponse class]])
                                      {
                                          NSLog(@"Response HTTP Status code: %ld\n", (long)[(NSHTTPURLResponse *)response statusCode]);
                                          NSLog(@"Response HTTP Headers:\n%@\n", [(NSHTTPURLResponse *)response allHeaderFields]);
                                      }
                                      
                                      //NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      //NSLog(@"Response:%@", responseStr);
                                      
                                      if(error)
                                      {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              //Delegate Error response
                                              if(self.delegate && [self.delegate respondsToSelector:@selector(tmdbDataFetcher:failedToExtractDataWithError:)])
                                              {
                                                  [self.delegate tmdbDataFetcher:self failedToExtractDataWithError:error];
                                              }
                                          });
                                      }
                                      else
                                      {
                                          [self parseDataAndDelegate:data];
                                      }
                                  }];
    
    //Request Data
    [task resume];
    self.dataTask = task;
}

-(void) cancelSearchRequest
{
    if(self.dataTask.state == NSURLSessionTaskStateRunning)
    {
        [self.dataTask cancel];
    }
}

#pragma mark - Life Cycle Methods

-(void) dealloc
{
    [self cancelSearchRequest];
}

@end
