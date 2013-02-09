//
//  GameResult.h
//  Matchismo
//
//  Created by Ryan Zulkoski on 2/8/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

+ (NSArray *)allGameResults;

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (strong, nonatomic) NSString *game;
@property (nonatomic) int score;

- (NSComparisonResult)compareDuration:(GameResult *)otherGameResult;
- (NSComparisonResult)compareScore:(GameResult *)otherGameResult;
- (NSComparisonResult)compareDate:(GameResult *)otherGameResult;

@end
