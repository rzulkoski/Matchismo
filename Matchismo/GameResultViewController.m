//
//  GameResultsViewController.m
//  Matchismo
//
//  Created by Ryan Zulkoski on 2/7/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"

@interface GameResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *display;
@property (nonatomic) SEL sortBySelector;
@property (nonatomic) BOOL sortInAscendingOrder;
@end

@implementation GameResultViewController

- (void)updateUI
{
    NSString *displayText = @"";
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"M/d/yy h:mm" options:0 locale:[NSLocale currentLocale]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey:nil ascending:self.sortInAscendingOrder selector:self.sortBySelector];
    [dateFormatter setDateFormat:formatString];
    for (GameResult *result in [[GameResult allGameResults] sortedArrayUsingDescriptors:@[sortOrder]]) {
        displayText = [displayText stringByAppendingFormat:@"Score: %d (%@, %0gs)\n", result.score, [dateFormatter stringFromDate:result.end], round(result.duration)];
    }
    self.display.text = displayText;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (IBAction)sortButtonPressed:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"By Duration"]) {
        [self setSortOrderAndSortBySelector:@"compareDuration:" defaultSortOrder:YES];
    } else if ([sender.titleLabel.text isEqualToString:@"By Score"]) {
        [self setSortOrderAndSortBySelector:@"compareScore:" defaultSortOrder:NO];
    } else if ([sender.titleLabel.text isEqualToString:@"By Date"]) {
        [self setSortOrderAndSortBySelector:@"compareDate:" defaultSortOrder:NO];
    }
    [self updateUI];
}

- (void)setSortOrderAndSortBySelector:(NSString *)selectorString defaultSortOrder:(BOOL)defaultSortOrder
{
    self.sortInAscendingOrder = (self.sortBySelector == NSSelectorFromString(selectorString) && self.sortInAscendingOrder == defaultSortOrder) ? !defaultSortOrder : defaultSortOrder;
    self.sortBySelector = NSSelectorFromString(selectorString);
}

- (void)setup
{
    self.sortBySelector = NSSelectorFromString(@"compareScore:");
    self.sortInAscendingOrder = NO;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup];
    return self;
}

@end
