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
@property (strong, nonatomic) NSMutableArray *flipHistory; // Stores the strings returned from the models flipCard function
@property (weak, nonatomic) IBOutlet UILabel *flipHistoryLabel;
@property (weak, nonatomic) IBOutlet UISlider *flipHistorySlider;
@property (strong, nonatomic) NSDictionary *flipSummaryAttributes;
@end

@implementation CardGameViewController

- (void)viewDidLoad {
    self.flipHistorySlider.minimumValue = 0;
    self.flipHistorySlider.maximumValue = 0;
    [self updateUI];
}

- (NSDictionary *)flipSummaryAttributes
{
    if (!_flipSummaryAttributes) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        _flipSummaryAttributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:12],
                                    NSParagraphStyleAttributeName : paragraphStyle };
    }
        
    return _flipSummaryAttributes;
}

- (NSMutableArray *)flipHistory
{
    if (!_flipHistory) _flipHistory = [[NSMutableArray alloc] init];
    return _flipHistory;
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self getDeck]
                                                      cardMatchMode:[self getCardMatchMode]
                                                         matchBonus:4
                                                    mismatchPenalty:2
                                                           flipCost:1];
    return _game;
}

- (Deck *)getDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)getCardMatchMode
{
    return 2;
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
    [self renderCards];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score]; // Make the score label match the score from our model.
    self.flipHistoryLabel.attributedText = ([self.flipHistory count] > 0) ? [self.flipHistory objectAtIndex:(int)self.flipHistorySlider.value] : nil; // If there are flips stored in our flipHistory array then
                                                                                                                                            // set the current flip being displayed to match the position
                                                                                                                                            // of the flip slider, otherwise sit it to be an empty string.
    self.flipHistoryLabel.alpha = (self.flipHistorySlider.value < self.flipHistorySlider.maximumValue) ? 0.3 : 1.0; // If current flipHistory being displayed is not the most recent flip then make it
                                                                                                                    // semi-transparent, otherwise make it fully opaque.
    // If the flipHistorySlider's min and max values are identical disable and hide the slider, otherwise enable and show the slider.
    self.flipHistorySlider.enabled = (self.flipHistorySlider.minimumValue == self.flipHistorySlider.maximumValue) ? NO : YES;
    self.flipHistorySlider.alpha = (self.flipHistorySlider.minimumValue == self.flipHistorySlider.maximumValue) ? 0.0: 1.0;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount]; // Update the total flip count display (includes flip cards faceUp and faceDown!).
}

- (void)renderCards
{
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.png"]; // Create an image object for our cardback image so it can be set properly.
    for (UIButton *cardButton in self.cardButtons) { // Do this to each of our card buttons
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]]; // Store a copy of the current Card in our collection
        [cardButton setTitle:card.contents forState:UIControlStateSelected]; // Show contents of card if button is in selected/enabled state.
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled]; // Show contents of card if button is in selected/disabled state.
        cardButton.selected = card.isFaceUp;
        [cardButton setImageEdgeInsets:UIEdgeInsetsMake(4.0, 3.0, 5.0, 3.0)];
        [cardButton setImage:(!cardButton.selected) ? cardBackImage : nil forState:UIControlStateNormal]; // If the cardButton is not selected (face down) then show cardBack, otherwise show face.
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0; // If card isn't in play anymore make it semi-transparent, otherwise it should be fully opaque.
    }
}

// The user has requested to flip an enabled card. Track history and increment counters and slider as needed.
- (IBAction)flipCard:(UIButton *)sender
{
    NSArray *flipResult = nil;
    NSMutableAttributedString *flipSummary = nil;
    
    flipResult = [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    flipSummary = [self parseFlipResult:flipResult];
    if (flipSummary) [self.flipHistory addObject:flipSummary];
    self.flipCount++;
    self.flipHistorySlider.maximumValue = [self.flipHistory count]-1;
    self.flipHistorySlider.value = self.flipHistorySlider.maximumValue;
    [self updateUI];
}

- (NSMutableAttributedString *)parseFlipResult:(NSArray *)flipResult
{
    NSMutableAttributedString *flipSummary = nil;
    NSAttributedString *cardSeparator = [[NSAttributedString alloc] initWithString:@"&"];
    
    if ([flipResult count] > 0) {
        if ([flipResult[0] isKindOfClass:[NSNumber class]]) {
            int matchPoints = [flipResult[0] integerValue];
            NSArray *cards = [flipResult subarrayWithRange:NSMakeRange(1, [flipResult count]-1)];
            if (matchPoints > 0) {
                flipSummary = [[NSMutableAttributedString alloc] initWithString:@"Matched "];
                [flipSummary appendAttributedString:[self createAttributedStringFromCards:cards  withSeparator:cardSeparator]];
                [flipSummary appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" for %d points", [flipResult[0] integerValue]]]];
            } else {
                flipSummary = [[NSMutableAttributedString alloc] initWithAttributedString:[self createAttributedStringFromCards:cards withSeparator:cardSeparator]];
                [flipSummary appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" don't match (%d penalty)", matchPoints]]];
            }
        } else {
            Card *flippedCard = flipResult[0];
            flipSummary = [[NSMutableAttributedString alloc] initWithString:@"Flipped up "];
            [flipSummary appendAttributedString:flippedCard.attributedContents];
        }
        [flipSummary addAttributes:self.flipSummaryAttributes range:NSMakeRange(0, [flipSummary length])];
    }
    
    return flipSummary;
}

- (NSMutableAttributedString *)createAttributedStringFromCards:(NSArray *)cards withSeparator:(NSAttributedString *)separator
{
    NSMutableAttributedString *stringOfCards = nil;
    Card * currentCard = nil;
    
    if ([cards count] > 0) {
        currentCard = cards[0];
        stringOfCards = [[NSMutableAttributedString alloc] initWithAttributedString:currentCard.attributedContents];
        for (int i = 1; i < [cards count]; i++) {
            currentCard = cards[i];
            [stringOfCards appendAttributedString:separator];
            [stringOfCards appendAttributedString:currentCard.attributedContents];
        }
    }
    
    return stringOfCards;
}

// Reset the game elements for a new game using a new Deck.
- (IBAction)dealNewGame {
    self.game = nil; // Reset our model
    self.flipCount = 0;
    self.flipHistory = nil; // Reset our flipHistory tracking array.
    self.flipHistorySlider.maximumValue = 0;
    self.flipHistorySlider.value = 0.0;
    [self updateUI];
}

@end
