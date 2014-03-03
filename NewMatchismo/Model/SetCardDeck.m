//
//  SetCardDeck.m
//  NewMatchismo
//
//  Created by hcfilippo on 14-2-24.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import "SetCardDeck.h"
#import "Deck.h"

@implementation SetCardDeck

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        for (NSInteger symbol = 0; symbol < 3; symbol++)
            for (NSUInteger number = 0; number < 3; number++)
                for (NSUInteger shading = 0; shading < 3; shading++)
                    for (NSUInteger color = 0; color < 3; color++)
                    {
                        SetCard *card = [[SetCard alloc] init];
                        card.symbol = symbol;
                        card.shading = shading;
                        card.number = number;
                        card.color = color;
                        [self addCard:card];
                    }
    }
    return self;
}
@end
