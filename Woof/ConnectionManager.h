//
//  ConnectionManager.h
//  Woof
//
//  Created by Patrick Whitehead on 2016-03-20.
//  Copyright © 2016 Patrick Whitehead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Stripe/Stripe.h>
#import "WoofCreditCard.h"
#import "WoofPet.h"

@interface ConnectionManager : NSObject

+ (id)sharedManager;

- (void)getCreditCardsWithCustomerId:(NSString *)customerId completion:(void (^)(NSArray *cards, NSError *error))completion;

- (void)saveCardWithToken:(STPToken *)token completion:(void (^)(BOOL success, NSArray *cards, NSError *error))completion;

- (void)chargeAmount:(double)amount withCustomerId:(NSString *)customerId completion:(void (^)(BOOL success, NSError *error))completion;

- (void)deleteCardWithCardId:(NSString *)cardId andStripeId:(NSString *)stripeId completion:(void (^)(NSError *error))completion;

- (void)editCardWithCardInfo:(WoofCreditCard *)card setPrimary:(BOOL)primary completion:(void (^)(NSError *error))completion;


- (void)getPetsWithCompletion:(void (^)(NSArray *pets, NSError *error))completion;

- (void)savePet:(WoofPet *)pet completion:(void (^)(BOOL success, NSError *error))completion;



@end
