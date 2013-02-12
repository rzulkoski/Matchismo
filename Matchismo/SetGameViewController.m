//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Ryan Zulkoski on 2/6/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "CardMatchingGame.h"

#define CARD_MATCH_MODE 3

@interface CardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation SetGameViewController

@synthesize game = _game;

- (NSString *)gameName
{
    return @"Set";
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[[SetCardDeck alloc] init]
                                                      cardMatchMode:CARD_MATCH_MODE
                                                         matchBonus:4
                                                    mismatchPenalty:2
                                                           flipCost:1];
    return _game;
}

- (void)renderCards
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        if (card.unplayable) {
            cardButton.selected = NO;
            [cardButton setAttributedTitle:nil forState:UIControlStateNormal];
        } else {
            [cardButton setAttributedTitle:card.attributedContents forState:UIControlStateNormal];
            [cardButton setAttributedTitle:card.attributedContents forState:UIControlStateSelected];
            cardButton.selected = card.isFaceUp;
        }
        [cardButton setBackgroundColor:(cardButton.isSelected) ? [UIColor lightGrayColor] : nil];
    }
}

@end
