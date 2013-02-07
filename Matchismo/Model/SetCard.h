//
//  SetCard.h
//  Matchismo
//
//  Created by Ryan Zulkoski on 2/6/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *symbol;
@property (nonatomic) int number;
@property (strong, nonatomic) NSString *shade;
@property (strong, nonatomic) NSString *color;

+ (NSArray *)validSymbols;
+ (NSUInteger)maxNumber;
+ (NSArray *)validShades;
+ (NSArray *)validColors;

@end
