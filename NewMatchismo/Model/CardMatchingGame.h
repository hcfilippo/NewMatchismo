//
//  CardMatchingGame.h
//  NewMatchismo
//
//  Created by hcfilippo on 14-2-17.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSInteger)count usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSInteger)index;
- (void)chooseCardAtIndex:(NSInteger)index gameMode:(NSInteger) mode;
- (Card *)cardAtIndex:(NSInteger)index;

- (BOOL) drawCards:(NSInteger)count usingDeck:(Deck *)deck;

@property (nonatomic,readonly) NSInteger score;
@property (nonatomic,readonly) NSString *message;

@end
