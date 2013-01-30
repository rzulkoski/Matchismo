//
//  Card.m
//  Matchismo
//
//  Created by Ryan Zulkoski on 1/29/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "Card.h"

@interface Card()

@end

@implementation Card

- (int)match:(Card *)card
{
    int score = 0;
    
    if ([card.contents isEqualToString:self.contents]) {
        score = 1;
    }
    
    return score;
}

@end
