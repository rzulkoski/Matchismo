//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Ryan Zulkoski on 2/6/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "PlayingCardDeck.h" // TEMP!
#import "PlayingCard.h"     // TEMP!
#import "PlayingCardCollectionViewCell.h" // TEMP!
#import "CardMatchingGame.h"

#define CARD_MATCH_MODE 3

@interface CardGameViewController ()
//@property (strong, nonatomic) IBOutlet UIView *playingCardView;
@end

@implementation SetGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)startingCardCount
{
    return 1;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            if (animate && playingCardView.isFaceUp != playingCard.isFaceUp) {
                [UIView transitionWithView:playingCardView
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{
                                    playingCardView.faceUp = playingCard.isFaceUp;
                                }
                                completion:NULL];
            } else {
                playingCardView.faceUp = playingCard.isFaceUp;
            }
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

/*- (CardMatchingGame *)game
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
}*/

@end
