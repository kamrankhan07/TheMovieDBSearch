//
//  SettingsTableViewController.m
//  TheMovieDBSearch
//
//  Created by Kamran Khan on 26/06/2015.
//  Copyright (c) 2015 Kamran Khan. All rights reserved.
//

#import "SettingsTableViewController.h"

@implementation SettingsTableViewController

@synthesize adultContentSwitch;
@synthesize showPosterSwitch;

#pragma mark - 

-(IBAction) changeAdultContentSetting:(id)sender
{
    UISwitch *switchControl = (UISwitch *)sender;
    
    BOOL val = switchControl.isOn;
    
    if(switchControl.tag == 0)
    {
        [[SettingsManager sharedInstance] saveSettingValue:val forKey:SettingKey_ShowAdultContent];
    }
    else if(switchControl.tag == 1)
    {
        [[SettingsManager sharedInstance] saveSettingValue:val forKey:SettingKey_ShowPosters];
    }
}

#pragma mark - View Life Cycle

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.adultContentSwitch setOn:[[SettingsManager sharedInstance] getSettingValueForKey:SettingKey_ShowAdultContent] animated:NO];
    [self.showPosterSwitch setOn:[[SettingsManager sharedInstance] getSettingValueForKey:SettingKey_ShowPosters] animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
