//
//  Setting.m
//  Matchismo
//
//  Created by Ryan Zulkoski on 2/12/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "Settings.h"

#define SETTINGS_KEY @"Settings"
#define REPLACE_MATCHED_CARDS_KEY @"Replace_Matched_Cards"

@implementation Settings

+ (NSDictionary *)getSettingsFromUserDefaults
{
    NSDictionary *settingsFromUserDefaults = [[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_KEY];
    
    if (!settingsFromUserDefaults) {
        settingsFromUserDefaults = @{ REPLACE_MATCHED_CARDS_KEY : @(NO) };
    }
    
    return settingsFromUserDefaults;
}

+ (BOOL)replaceMatchedCards
{
    NSDictionary *settingsFromUserDefaults = [Settings getSettingsFromUserDefaults];
    
    return [settingsFromUserDefaults[REPLACE_MATCHED_CARDS_KEY] boolValue];
}

+ (void)setReplaceMatchedCards:(BOOL)replaceMatchedCards
{
    NSMutableDictionary *mutableSettingsFromUserDefaults = [[Settings getSettingsFromUserDefaults] mutableCopy];
    
    mutableSettingsFromUserDefaults[REPLACE_MATCHED_CARDS_KEY] = @(replaceMatchedCards);
    [[NSUserDefaults standardUserDefaults] setObject:mutableSettingsFromUserDefaults forKey:SETTINGS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
