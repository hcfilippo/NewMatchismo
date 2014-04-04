//
//  SetGameViewController.m
//  NewMatchismo
//
//  Created by hcfilippo on 14-2-24.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetMatchingGame.h"
#import "SetCardDeck.h"
#import "Grid.h"
#import "SetCardView.h"
#import "Deck.h"

@interface SetGameViewController () <UIDynamicAnimatorDelegate>
@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) SetMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(SetCardView) NSMutableArray *setCardViews;
@property (strong, nonatomic) UIView *cardAreaView;
@property (nonatomic) NSInteger numberOfCards;
@property (strong, nonatomic) Grid *grid;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property BOOL piled;

- (IBAction)touchRestartButton:(id)sender;
- (IBAction)touchDrawCardsButton:(id)sender;

@end

@implementation SetGameViewController


- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        _animator.delegate = self;
    }
    return _animator;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self.cardAreaView setFrame:CGRectMake(10, 70, self.view.bounds.size.width - 20, self.view.bounds.size.height - 160)];
    
    [self.view addSubview:self.cardAreaView];
    
    [self resetGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.cardAreaView setFrame:CGRectMake(10, 70, self.view.bounds.size.width - 20, self.view.bounds.size.height - 160)];
    if (!self.piled)
    {
        [self reCalculateGrid];
    }
    else
    {
        [self animatePileViews:[self.cardAreaView subviews]];
    }
}

- (SetMatchingGame *)game
{
    if (!_game) _game = [[SetMatchingGame alloc] initWithCardCount:[self.setCardViews count]
                                                          usingDeck:[self createDeck]];
    return _game;
}



- (IBAction)touchRestartButton:(UIButton *)sender
{
    [self resetGame];
}

- (IBAction)touchDrawCardsButton:(id)sender
{
    
    if (![self.game drawCards:3 usingDeck:self.deck])
    {
        return;
    }
    
    self.numberOfCards = [[self.cardAreaView subviews] count] + 3;
    self.grid.minimumNumberOfCells = self.numberOfCards;
    
    for (int i = 0; i < 3; i++)
    {
        SetCardView *cardView = [[SetCardView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.bounds.size.height, 0, 0)];
        
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];

        [cardView addGestureRecognizer:tgr];
        [cardView addGestureRecognizer:pgr];
        
        [self.cardAreaView addSubview:cardView];
        [self.setCardViews addObject:cardView];
    }
    
    [self reCalculateGrid];
    [self updateUI];
}

- (void)resetGrid
{
    self.grid = [[Grid alloc] init];
    self.grid.size = CGSizeMake(self.cardAreaView.frame.size.width, self.cardAreaView.frame.size.height);
    self.grid.cellAspectRatio = (CGFloat)(3.0)/(2.0);
    self.grid.minimumNumberOfCells = self.numberOfCards;
}


- (void) resetGame
{
    self.piled = NO;
    
    [[self.cardAreaView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.setCardViews removeAllObjects];
    
    self.numberOfCards = 12;
    self.game = [[SetMatchingGame alloc] initWithCardCount:self.numberOfCards
                                              usingDeck:[self createDeck]];
    
    for (int i = 0; i < self.numberOfCards; i++)
    {
        SetCardView *cardView = [[SetCardView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.bounds.size.height, 0, 0)];
        
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [cardView addGestureRecognizer:tgr];
        [cardView addGestureRecognizer:pgr];
        
        
        [self.cardAreaView addSubview:cardView];
        [self.setCardViews addObject:cardView];
    }
    
    [self reCalculateGrid];
    [self updateUI];
}


- (void)updateUI
{
    NSMutableArray *viewsToRemove = [[NSMutableArray alloc] init];
    
    
    for (SetCardView *cardView in self.setCardViews)
    {
        int cardIndex = [self.setCardViews indexOfObject:cardView];
        Card *card = [self.game cardAtIndex:cardIndex];
        cardView.chosen = card.chosen;
        cardView.matched = card.matched;
        
        SetCard *setCard = (SetCard *)card;
        cardView.symbol = setCard.symbol;
        cardView.number = setCard.number;
        cardView.shading = setCard.shading;
        cardView.color = setCard.color;
        
        if (card.matched && !cardView.removed)
        {
            [viewsToRemove addObject:cardView];
        }
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    if ([viewsToRemove count])
    {
        [self animateRemovingViews:viewsToRemove];
    }
}


- (void)reCalculateGrid
{
    int currentCardNumber = [[self.cardAreaView subviews] count];
    self.numberOfCards = currentCardNumber;
    self.grid.minimumNumberOfCells = self.numberOfCards;
    [self resetGrid];

    if ([[self.cardAreaView subviews] count])
    {
        [self animateReSizeViews:[self.cardAreaView subviews]];
    }
}


#pragma mark - Animation

- (void)animateReSizeViews:(NSArray *)viewsToReSize
{
    NSUInteger rowCount = self.grid.rowCount;
    NSUInteger columnCount = self.grid.columnCount;
    Grid *grid = self.grid;
    int currentCardNumber = [viewsToReSize count];

    [UIView animateWithDuration:0.8 animations:^{
        
        int cardCount = 0;
        for (NSUInteger row = 0; row < rowCount; row++)
        {
            for (NSUInteger column = 0; column < columnCount; column++)
            {
                if (cardCount < currentCardNumber)
                {
                    CGRect frame = [grid frameOfCellAtRow:row inColumn:column];
                    [[viewsToReSize objectAtIndex:cardCount] resetFrame:frame];
                }
                cardCount++;
            }
        }
        
    }
                     completion:^(BOOL finished) {

                     }];
}


- (void)animateRemovingViews:(NSArray *)viewsToRemove
{
    [UIView animateWithDuration:0.8 animations:^{
        for (UIView *card in viewsToRemove) {
            int x = (arc4random()%(int)(self.view.bounds.size.width*5)) - (int)self.view.bounds.size.width*2;
            int y = self.view.bounds.size.height;
            card.center = CGPointMake(x, -y);
        }
    }
                     completion:^(BOOL finished) {
                         [viewsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                         [viewsToRemove makeObjectsPerformSelector:@selector(removeFromDeck)];
                         [self reCalculateGrid];
                     }];
}

- (void)animatePileViews:(NSArray *)viewsToPile
{
    [UIView animateWithDuration:0.8 animations:^{
        for (UIView *card in viewsToPile) {
            int x = self.cardAreaView.center.x;
            int y = self.cardAreaView.frame.origin.y;
            card.center = CGPointMake(x, y);
        }
    }
                     completion:^(BOOL finished) {
                     }];

}


- (NSInteger)numberOfCards
{
    if (!_numberOfCards) _numberOfCards = 0;
    return _numberOfCards;
}


- (NSMutableArray *)setCardViews
{
    if (!_setCardViews) _setCardViews = [[NSMutableArray alloc] init];
    return _setCardViews;
}

- (UIView *)cardAreaView
{
    if (!_cardAreaView) _cardAreaView = [[UIView alloc]init];
    return _cardAreaView;
}


- (Deck *)deck
{
    if (!_deck) _deck = [self createDeck];
    return _deck;
}

- (Deck *)createDeck
{
    self.deck = [[SetCardDeck alloc] init];
    return self.deck;
}


- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    if (self.piled)
    {
        if (recognizer.state == UIGestureRecognizerStateEnded)
        {
            [self reCalculateGrid];
        }
        self.piled = NO;
    }
    else {
        SetCardView *view = (SetCardView *)recognizer.view;
        if (recognizer.state == UIGestureRecognizerStateEnded)
        {
            int cardIndex = [self.setCardViews indexOfObject:view];
            Card *card = [self.game cardAtIndex:cardIndex];
            
            if (!card.matched)
            {
                if (card.chosen)
                {
                    card.chosen = !card.chosen;
                }
                else
                {
                    [self.game chooseCardAtIndex:cardIndex];
                }
                [self updateUI];
            }
        }
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    if (self.piled)
    {
        CGPoint gesturePoint = [recognizer locationInView:self.cardAreaView];
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            
        } else if (recognizer.state == UIGestureRecognizerStateChanged) {
            for (UIView *card in [self.cardAreaView subviews])
            {
                card.center = gesturePoint;
            }
        } else if (recognizer.state == UIGestureRecognizerStateEnded) {
            
        }
    }

}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender
{
    if (!self.piled)
    {
        [self animatePileViews:[self.cardAreaView subviews]];
        self.piled = YES;
    }
}

@end
