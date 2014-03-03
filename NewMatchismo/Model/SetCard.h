//
//  SetCard.h
//  NewMatchismo
//
//  Created by hcfilippo on 14-2-24.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"


@interface SetCard : Card
@property (nonatomic) NSInteger symbol;
@property (nonatomic) NSInteger number;
@property (nonatomic) NSInteger shading;
@property (nonatomic) NSInteger color;

+ (NSArray*) validSymbols;
@end
