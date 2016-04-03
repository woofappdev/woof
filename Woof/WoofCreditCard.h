//
//  WoofCreditCard.h
//  Woof
//
//  Created by Patrick Whitehead on 2016-03-20.
//  Copyright © 2016 Patrick Whitehead. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WoofCreditCard : NSObject

@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *last4;
//@property (nonatomic, strong) NSString *month;
//@property (nonatomic, strong) NSString *year;

@property (nonatomic, strong) NSNumber *month;
@property (nonatomic, strong) NSNumber *year;

@property (nonatomic, strong) NSString *stripeId;
@property (nonatomic, strong) NSString *cardId;

@property (nonatomic, strong) NSString *cardName;
@property (nonatomic, strong) NSString *cvc;

@property BOOL isPrimaryCard;

@end
