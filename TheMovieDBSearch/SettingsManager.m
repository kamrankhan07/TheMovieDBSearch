//
//  SettingsManager.m
//  TheMovieDBSearch
//
//  Created by Kamran Khan on 26/06/2015.
//  Copyright (c) 2015 Kamran Khan. All rights reserved.
//

#import "SettingsManager.h"

@implementation SettingsManager

#pragma mark - Setting Methods

-(void) initSettingsOnFirstLaunch
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:SettingKey_ShowAdultContent] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:SettingKey_ShowAdultContent];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:SettingKey_ShowPosters];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void) saveSettingValue:(BOOL)val forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:val] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL) getSettingValueForKey:(NSString *)key
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:key] boolValue];
}

#pragma mark - Configuration Settings

-(BOOL) isNeededToUpdateConfigurationData
{
    if(![[NSUserDefaults standardUserDefaults] objectForKey:SettingKey_ConfigurationData])
    {
        return YES;
    }
    
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:SettingKey_ConfigurationDataFetchedDate];
    if(date && ([[NSDate date] timeIntervalSinceDate:date] > (NoOfDaysAfterWhichToRefreshConfigurationData * 86400)))
    {
        return YES;
    }
    return NO;
}

-(void) saveConfigurationData:(NSDictionary *)configurationDict
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:configurationDict forKey:SettingKey_ConfigurationData];
    [defaults setObject:[NSDate date] forKey:SettingKey_ConfigurationDataFetchedDate];
    [defaults synchronize];
}

-(NSDictionary *) getConfigurationData
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:SettingKey_ConfigurationData];
}

#pragma mark - sharedInstance

static SettingsManager *sharedInstance;

+(SettingsManager *) sharedInstance
{
    @synchronized(self)
    {
        if (!sharedInstance)
        {
            sharedInstance = [[SettingsManager alloc] init];
        }
    }
    return sharedInstance;
}

+(id) alloc
{
    @synchronized(self)
    {
        NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of a singleton SettingsManager.");
        sharedInstance = [super alloc];
    }
    return sharedInstance;
}

@end


