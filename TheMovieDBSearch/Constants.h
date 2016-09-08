//
//  Constants.h
//  TheMovieDBSearch
//
//  Created by Kamran Khan on 26/06/2015.
//  Copyright (c) 2015 Kamran Khan. All rights reserved.
//

#ifndef TheMovieDBSearch_Constants_h
#define TheMovieDBSearch_Constants_h

#define NoOfDaysAfterWhichToRefreshConfigurationData 5
#define NextPageReloadingMaxTryCount 5

enum {
    PosterSize_w92,
    PosterSize_w154,
    PosterSize_w185,
    PosterSize_w342,
    PosterSize_w500,
    PosterSize_w780,
    PosterSize_original,
    BackdropSize_w300,
    BackdropSize_w780,
    BackdropSize_w1280,
    BackdropSize_original,
    UnknownSize,
};
#define PosterSizesList @[@"w92", @"w154", @"w185", @"w342", @"w500", @"w780", @"original", @"w300", @"w780", @"w1280", @"original"]
#define PosterSizeStr(enumVal) (enumVal < UnknownSize) ? PosterSizesList[enumVal] : @"original"



#endif
