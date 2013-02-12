//
//  MatchGameViewController.m
//  Matchismo
//
//  Created by Ryan Zulkoski on 2/12/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "MatchGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

#define CARD_MATCH_MODE 2

@interface MatchGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation MatchGameViewController

- (NSString *)gameName
{
    return @"Match";
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[[PlayingCardDeck alloc] init]
                                                      cardMatchMode:CARD_MATCH_MODE
                                                         matchBonus:4
                                                    mismatchPenalty:2
                                                           flipCost:1];
    return _game;
}

- (void)renderCards
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
}

@end
