//
//  SetMatchingGame.h
//  NewMatchismo
//
//  Created by hcfilippo on 14-2-24.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
@interface SetMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSInteger)count usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSInteger)index;
- (Card *)cardAtIndex:(NSInteger)index;

-(void)removeCardAtIndex:(NSInteger)index;

- (BOOL) drawCards:(NSInteger)count usingDeck:(Deck *)deck;

@property (nonatomic,readonly) NSInteger score;
@property (nonatomic,readonly) NSString *message;

@end
