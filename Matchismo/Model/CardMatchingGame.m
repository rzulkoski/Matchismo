//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Ryan Zulkoski on 1/30/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@property (readwrite, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *flipHistory; // of NSString
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)flipHistory
{
    if (!_flipHistory) _flipHistory = [[NSMutableArray alloc] init];
    return _flipHistory;
}

- (NSString *)flipHistoryForFlip:(NSUInteger)flipIndex
{
    return (flipIndex < [self.flipHistory count]) ? [self.flipHistory objectAtIndex:flipIndex] : nil;
}

- (NSUInteger)numberOfFlips
{
    return [self.flipHistory count];
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    BOOL matchAttempted = NO;
    
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    matchAttempted = YES;
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        [self.flipHistory addObject:[NSString stringWithFormat:@"Matched %@ & %@ for %d points", card, otherCard, matchScore * MATCH_BONUS]];
                    } else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        [self.flipHistory addObject:[NSString stringWithFormat:@"%@ and %@ don't match! %d point penalty!", card, otherCard, MISMATCH_PENALTY]];
                    }
                    break;
                }
            }
            self.score -= FLIP_COST;
            if (!matchAttempted) [self.flipHistory addObject:[NSString stringWithFormat:@"Flipped up %@", card]];
        }
        card.faceUp = !card.isFaceUp;
    }
}

@end
