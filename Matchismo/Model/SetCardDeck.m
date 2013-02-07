//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Ryan Zulkoski on 2/6/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id)init
{
    self = [super init];
    
    if (self) {
        for (NSString *symbol in [SetCard validSymbols]) {
            for (NSUInteger number = 1; number <= [SetCard maxNumber]; number++) {
                for (NSString *shade in [SetCard validShades]) {
                    for (NSString *color in [SetCard validColors]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.symbol = symbol;
                        card.number = number;
                        card.shade = shade;
                        card.color = color;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
