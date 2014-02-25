//
//  CardGameViewController.m
//  NewMatchismo
//
//  Created by hcfilippo on 14-2-16.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "HistoryViewController.h"

@interface CardGameViewController ()
- (IBAction)touchCardButton:(UIButton *)sender;
- (IBAction)touchRestartButton:(UIButton *)sender;
- (IBAction)touchGameModeSwitch:(id)sender;
@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) CardMatchingGame *game;
@property (nonatomic, strong) NSMutableString *history;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) int gameMode;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation CardGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CardGameHistory"])
    {
        if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
            HistoryViewController *hvc = (HistoryViewController *) segue.destinationViewController;
            hvc.historyText = self.history;
        }
    }

}


- (NSMutableString *)history
{
    if (!_history) {
            _history = [[NSMutableString alloc] init];
        [_history appendString:@"Start a new game"];
    }
    return _history;
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}


- (Deck *)deck
{
    if (!_deck) _deck = [self createDeck];
    return _deck;
}

- (Deck *)createDeck    // abstract
{
    return nil;
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex gameMode:self.gameMode];
    [self updateUI];
}

- (IBAction)touchRestartButton:(UIButton *)sender
{
    [self resetGame];
}

- (IBAction)touchGameModeSwitch:(id)sender
{
    int selectedIndex = [sender selectedSegmentIndex];
    self.gameMode = selectedIndex;
    [self resetGame];
}

- (void) resetGame
{
    _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                              usingDeck:[self createDeck]];
    for (UIButton *cardButton in self.cardButtons) {
        [cardButton setTitle:@"" forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[UIImage imageNamed:@"cardback"] forState:UIControlStateNormal];
        cardButton.enabled = YES;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.messageLabel.text = [NSString stringWithFormat:@""];
    [self.history appendString:@"\n\nStart a new game"];
}


- (void) updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.messageLabel.text = [self.game message];
    [self.history appendString:[NSString stringWithFormat:@"\n%@", self.messageLabel.text]];
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}



@end
