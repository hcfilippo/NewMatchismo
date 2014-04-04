//
//  SetCardView.h
//  NewMatchismo
//
//  Created by hcfilippo on 14-3-4.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (nonatomic) NSUInteger symbol;
@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger shading;
@property (nonatomic) NSUInteger color;

@property (nonatomic) BOOL chosen;
@property (nonatomic) BOOL matched;
@property (nonatomic) BOOL removed;

- (id)resetFrame:(CGRect)frame;
- (void)removeFromDeck;

@end
