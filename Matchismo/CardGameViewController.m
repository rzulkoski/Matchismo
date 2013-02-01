//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ryan Zulkoski on 1/29/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchModeControl;
@property (weak, nonatomic) IBOutlet UISlider *flipHistorySlider;
@end

@implementation CardGameViewController

- (void)viewDidLoad {
    for (UIButton *cardButton in self.cardButtons) {
        [cardButton setImageEdgeInsets:UIEdgeInsetsMake(4.0, 3.0, 5.0, 3.0)];
    }
    CGRect frame = self.matchModeControl.frame;
    self.flipHistorySlider.minimumValue = 0;
    self.flipHistorySlider.maximumValue = 0;
    [self.matchModeControl setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 32.0)];
    [self updateUI];
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[[PlayingCardDeck alloc] init]
                                                      cardMatchMode:self.matchModeControl.selectedSegmentIndex+2];
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (IBAction)newMatchModeSelected {
    [self dealNewGame];
}

- (IBAction)flipHistorySliderMoved {
    self.flipHistorySlider.value = floorf(self.flipHistorySlider.value);
    [self updateUI];
    NSLog(@"Slider Moved To %f", self.flipHistorySlider.value);
}

- (void)updateUI
{
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.png"];
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        [cardButton setImage:(cardButton.selected) ? nil : cardBackImage forState:UIControlStateNormal];
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.matchModeControl.alpha = self.matchModeControl.enabled ? 1.0: 0.3;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.lastFlipLabel.text = ([self.game.flipHistory count] > 0) ? [self.game.flipHistory objectAtIndex:(int)self.flipHistorySlider.value] : nil;
    self.lastFlipLabel.alpha = (self.flipHistorySlider.value < self.flipHistorySlider.maximumValue) ? 0.3 : 1.0;
    self.flipHistorySlider.enabled = (self.flipHistorySlider.minimumValue == self.flipHistorySlider.maximumValue) ? NO : YES;
    self.flipHistorySlider.alpha = (self.flipHistorySlider.minimumValue == self.flipHistorySlider.maximumValue) ? 0.0: 1.0;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    self.matchModeControl.enabled = NO;
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    self.flipHistorySlider.maximumValue = [self.game.flipHistory count]-1;
    self.flipHistorySlider.value = self.flipHistorySlider.maximumValue;
    [self updateUI];
}

- (IBAction)dealNewGame {
    self.game = nil;
    self.flipCount = 0;
    self.flipHistorySlider.maximumValue = 0;
    self.flipHistorySlider.value = 0.0;
    self.matchModeControl.enabled = YES;
    [self updateUI];
}

@end
