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
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchModeControl;
@property (strong, nonatomic) NSMutableArray *flipHistory; // Stores the strings returned from the models flipCard function
@property (weak, nonatomic) IBOutlet UILabel *flipHistoryLabel;
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

- (NSMutableArray *)flipHistory
{
    if (!_flipHistory) _flipHistory = [[NSMutableArray alloc] init];
    return _flipHistory;
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

- (IBAction)flipHistorySliderMoved {
    self.flipHistorySlider.value = floorf(self.flipHistorySlider.value); // Force slider to use integer steps (0.0, 1.0, 2.0, etc...)
    [self updateUI];
}

// Update our View to match our model's state.
- (void)updateUI
{
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.png"]; // Create an image object for our cardback image so it can be set properly.
    for (UIButton *cardButton in self.cardButtons) { // Do this to each of our card buttons
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]]; // Store a copy of the current Card in our collection
        [cardButton setTitle:card.contents forState:UIControlStateSelected]; // Show contents of card if button is in selected/enabled state.
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled]; // Show contents of card if button is in selected/disabled state.
        cardButton.selected = card.isFaceUp;
        [cardButton setImage:(!cardButton.selected) ? cardBackImage : nil forState:UIControlStateNormal]; // If the cardButton is not selected (face down) then show cardBack, otherwise show face.
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0; // If card isn't in play anymore make it semi-transparent, otherwise it should be fully opaque.
    }
    self.matchModeControl.alpha = self.matchModeControl.enabled ? 1.0: 0.3; // If matchModeControl is enabled make it fully opaque, otherwise is should be semi-transparent.
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score]; // Make the score label match the score from our model.
    self.flipHistoryLabel.text = ([self.flipHistory count] > 0) ? [self.flipHistory objectAtIndex:(int)self.flipHistorySlider.value] : nil; // If there are flips stored in our flipHistory array then
                                                                                                                                            // set the current flip being displayed to match the position
                                                                                                                                            // of the flip slider, otherwise sit it to be an empty string.
    self.flipHistoryLabel.alpha = (self.flipHistorySlider.value < self.flipHistorySlider.maximumValue) ? 0.3 : 1.0; // If current flipHistory being displayed is not the most recent flip then make it
                                                                                                                    // semi-transparent, otherwise make it fully opaque.
    // If the flipHistorySlider's min and max values are identical disable and hide the slider, otherwise enable and show the slider.
    self.flipHistorySlider.enabled = (self.flipHistorySlider.minimumValue == self.flipHistorySlider.maximumValue) ? NO : YES;
    self.flipHistorySlider.alpha = (self.flipHistorySlider.minimumValue == self.flipHistorySlider.maximumValue) ? 0.0: 1.0;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount]; // Update the total flip count display (includes flip cards faceUp and faceDown!).
}

// The user has requested to flip an enabled card. Track history and increment counters and slider as needed.
- (IBAction)flipCard:(UIButton *)sender
{
    NSString *flipSummary = nil; // Will store the result string returned from asking our model to flip a card.
    
    self.matchModeControl.enabled = NO; // Disable the matchModeControl since we know we are now in the middle of a game.
    flipSummary = [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]]; // Store the result string returned from asking our model to flip a card.
    if (flipSummary) [self.flipHistory addObject:flipSummary]; // If a result was returned (a card was turned faceUp) then add the summary to our flip history.
    self.flipCount++;
    self.flipHistorySlider.maximumValue = [self.flipHistory count]-1;   // Set the flipHistorySlider's maximum value to match the index of the last object in our flipHistory array.
    self.flipHistorySlider.value = self.flipHistorySlider.maximumValue; // Move slider current value to reflect the most recent flip.
    [self updateUI];
}

// Reset the game elements for a new game using a new Deck.
- (IBAction)dealNewGame {
    self.game = nil; // Reset our model
    self.flipCount = 0;
    self.flipHistory = nil; // Reset our flipHistory tracking array.
    self.flipHistorySlider.maximumValue = 0;
    self.flipHistorySlider.value = 0.0;
    self.matchModeControl.enabled = YES;
    [self updateUI];
}

@end
