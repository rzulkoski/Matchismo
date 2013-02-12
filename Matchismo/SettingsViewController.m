//
//  SettingsViewController.m
//  Matchismo
//
//  Created by Ryan Zulkoski on 2/12/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "SettingsViewController.h"
#import "GameResult.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *replaceMatchedCardsSwitch;
@end

@implementation SettingsViewController

- (IBAction)resetAllScoresPushed
{
    UIActionSheet *resetAllScoresConfirmation = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to reset all scores?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Reset Scores" otherButtonTitles:nil];
    [resetAllScoresConfirmation setActionSheetStyle:UIActionSheetStyleDefault];
    [resetAllScoresConfirmation showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: // Reset Scores
                [GameResult resetAllScores];
                break;
        case 1: // Cancel
                break;
    }
}


@end
