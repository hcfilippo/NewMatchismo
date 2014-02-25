//
//  CardGameViewController.h
//  NewMatchismo
//
//  Created by hcfilippo on 14-2-16.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//
//  Abstract class. Must implement methods as describe below.

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController


- (Deck *)createDeck;   //abstract

@end
