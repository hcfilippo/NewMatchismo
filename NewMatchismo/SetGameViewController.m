//
//  SetGameViewController.m
//  NewMatchismo
//
//  Created by hcfilippo on 14-2-24.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import "SetGameViewController.h"
#import "HistoryViewController.h"
#import "SetMatchingGame.h"
#import "SetCardDeck.h"

@interface SetGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic, strong) NSMutableString *history;
@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) SetMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
- (IBAction)touchRestartButton:(id)sender;
- (IBAction)touchCardButton:(UIButton *)sender;
@end

@implementation SetGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self resetGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SetGameHistory"])
    {
        if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
            HistoryViewController *hvc = (HistoryViewController *) segue.destinationViewController;
            hvc.historyText = self.history;
        }
    }
    
}

- (SetMatchingGame *)game
{
    if (!_game) _game = [[SetMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}


- (NSMutableString *)history
{
    if (!_history)
        _history = [[NSMutableString alloc] init];
    return _history;
}



- (IBAction)touchRestartButton:(UIButton *)sender
{
    [self resetGame];
}

- (void) resetGame
{
    _game = [[SetMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                              usingDeck:[self createDeck]];
    [self.history appendString:@"\n\nStart a new game"];
    self.messageLabel.text = [NSString stringWithFormat:@""];
    [self updateUI];
}



- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setAttributedTitle:[card getAttributedTitle] forState:UIControlStateNormal];
        cardButton.enabled = !card.isChosen;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.messageLabel.text = [self.game message];
    if (self.messageLabel.text != NULL) {
        [self.history appendString:[NSString stringWithFormat:@"\n%@", self.messageLabel.text]];
    }
}


- (Deck *)deck
{
    if (!_deck) _deck = [self createDeck];
    return _deck;
}

- (Deck *)createDeck    // abstract
{
    return [[SetCardDeck alloc] init];
}


- (IBAction)touchCardButton:(UIButton *)sender
{
    int cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex ];
    [self updateUI];
}
@end