//
//  SettingsTableViewController.h
//  TheMovieDBSearch
//
//  Created by Kamran Khan on 26/06/2015.
//  Copyright (c) 2015 Kamran Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UISwitch *adultContentSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *showPosterSwitch;

-(IBAction) changeAdultContentSetting:(id)sender;

@end
