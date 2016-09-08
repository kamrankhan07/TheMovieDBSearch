//
//  SettingsManager.h
//  TheMovieDBSearch
//
//  Created by Kamran Khan on 26/06/2015.
//  Copyright (c) 2015 Kamran Khan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SettingKey_ShowAdultContent @"ShowAdultContent"
#define SettingKey_ShowPosters @"ShowPosters"
#define SettingKey_ConfigurationData @"ConfigurationData"
#define SettingKey_ConfigurationDataFetchedDate @"ConfigurationDataFetchedDate"

@interface SettingsManager : NSObject

+(SettingsManager *) sharedInstance;

-(void) initSettingsOnFirstLaunch;
-(void) saveSettingValue:(BOOL)val forKey:(NSString *)key;
-(BOOL) getSettingValueForKey:(NSString *)key;

-(BOOL) isNeededToUpdateConfigurationData;
-(void) saveConfigurationData:(NSDictionary *)configurationDict;
-(NSDictionary *) getConfigurationData;

@end
