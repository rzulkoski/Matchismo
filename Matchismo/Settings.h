//
//  Setting.h
//  Matchismo
//
//  Created by Ryan Zulkoski on 2/12/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

+ (BOOL)replaceMatchedCards;
+ (void)setReplaceMatchedCards:(BOOL)replaceMatchedCards;

@end
