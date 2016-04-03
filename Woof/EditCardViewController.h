//
//  EditCardViewController.h
//  Woof
//
//  Created by Patrick Whitehead on 2016-03-21.
//  Copyright © 2016 Patrick Whitehead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WoofCreditCard.h"

@interface EditCardViewController : UIViewController

@property (nonatomic, strong) WoofCreditCard *card;

@property BOOL isOnlyCard;


//- (id)initWithCard:(WoofCreditCard *)card;

@end
