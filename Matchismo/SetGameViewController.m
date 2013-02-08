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

- (Deck *)getDeck
{
    return [[SetCardDeck alloc] init];
}

- (NSUInteger)getCardMatchMode
{
    return CARD_MATCH_MODE;
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
