//
//  AppDelegate.h
//  TheMovieDBSearch
//
//  Created by Kamran Khan on 24/06/2015.
//  Copyright (c) 2015 Kamran Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMDBDataFetcher.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    TMDBDataFetcher *fetcher;
}

@property (strong, nonatomic) UIWindow *window;


@end

