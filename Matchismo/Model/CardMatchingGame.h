//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Ryan Zulkoski on 1/30/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck
          cardMatchMode:(NSUInteger)numCards
             matchBonus:(NSUInteger)matchBonus
        mismatchPenalty:(NSUInteger)mismatchPenalty
               flipCost:(NSUInteger)flipCost;

- (NSArray *)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (readonly, nonatomic) int score;

@end
