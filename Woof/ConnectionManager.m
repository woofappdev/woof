//
//  ConnectionManager.m
//  Woof
//
//  Created by Patrick Whitehead on 2016-03-20.
//  Copyright © 2016 Patrick Whitehead. All rights reserved.
//

#import "ConnectionManager.h"
#import <Parse/Parse.h>


@implementation ConnectionManager


+ (id)sharedManager {
    static ConnectionManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {

    }
    return self;
}

#pragma mark Payment Methods

- (void)getCreditCardsWithCustomerId:(NSString *)customerId completion:(void (^)(NSArray *cards, NSError *error))completion {
    
    NSURL *url = [NSURL URLWithString:@"https://stripe-backend-woof.herokuapp.com/allcards"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *body     = [NSString stringWithFormat:@"customerId=%@", customerId];
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data,
                                   NSURLResponse *response,
                                   NSError *error) {
                   
                   if (!error) {
                       NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                       NSArray *jsonArray = jsonDict[@"data"];
                       NSMutableArray *cardArray = [NSMutableArray array];
                       for (NSDictionary *source in jsonArray) {
                           WoofCreditCard *card = [[WoofCreditCard alloc]init];
                           card.last4 = source[@"last4"];
                           card.brand = source[@"brand"];
                           card.month = source[@"exp_month"];
                           card.year = source[@"exp_year"];
                           card.stripeId = source[@"customer"];
                           card.cardId = source[@"id"];
                           card.cardName = source[@"metadata"][@"cardName"];
                           
                           if ([jsonDict[@"primaryCard"] isEqualToString:card.cardId]) {
                               card.isPrimaryCard = YES;
                           }
                           
                           [cardArray addObject:card];
                       }
                       completion(cardArray, nil);
                   }
                   else {
                       completion(nil, error);
                   }
                   
               }];
    [task resume];
}


- (void)saveCardWithToken:(STPToken *)token completion:(void (^)(BOOL success, NSArray *cards, NSError *error))completion {
    
    NSURL *url = [[NSURL alloc]init];
    NSString *body = [NSString string];

    if ([PFUser currentUser][@"stripeId"] == nil) {
        url = [NSURL URLWithString:@"https://stripe-backend-woof.herokuapp.com/customer"];
        body = [NSString stringWithFormat:@"stripeToken=%@&objectId=%@", token.tokenId, [PFUser currentUser].objectId];
    }
    else {
        url = [NSURL URLWithString:@"https://stripe-backend-woof.herokuapp.com/addcard"];
        body = [NSString stringWithFormat:@"stripeToken=%@&stripeId=%@", token.tokenId, [PFUser currentUser][@"stripeId"]];
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data,
                                   NSURLResponse *response,
                                   NSError *error) {
                   
                   if (!error) {
                       
                       NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                       
                       NSArray *jsonArray = jsonDict[@"data"];
                       
                       NSMutableArray *cardArray = [NSMutableArray array];
                       for (NSDictionary *source in jsonArray) {
                           WoofCreditCard *card = [[WoofCreditCard alloc]init];
                           card.last4 = source[@"last4"];
                           card.brand = source[@"brand"];
                           card.month = source[@"exp_month"];
                           card.year = source[@"exp_year"];
                           card.stripeId = source[@"customer"];
                           card.cardId = source[@"id"];
                           
                           [cardArray addObject:card];
                       }
                       
                       completion(YES, cardArray, nil);
                   }
                   else {
                       completion(NO, nil, error);
                   }
                   
               }];
    [task resume];
}

- (void)editCardWithCardInfo:(WoofCreditCard *)card setPrimary:(BOOL)primary completion:(void (^)(NSError *))completion {
    
    NSURL *url = [NSURL URLWithString:@"https://stripe-backend-woof.herokuapp.com/editcard"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *body     = [NSString stringWithFormat:@"stripeId=%@&cardId=%@&month=%@&year=%@&cardName=%@&setPrimary=%d", card.stripeId, card.cardId, card.month, card.year, card.cardName, (int)primary];
    NSLog(@"body: %@", body);
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data,
                                   NSURLResponse *response,
                                   NSError *error) {
                   
                   if (!error) {
                       completion(nil);
                   }
                   else {
                       completion(error);
                   }
                   
                   
                   // neccessary?
                   //                   NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                   
                   
               }];
    [task resume];
    
}



- (void)chargeAmount:(double)amount withCustomerId:(NSString *)customerId completion:(void (^)(BOOL, NSError *))completion{
    
    NSURL *url = [NSURL URLWithString:@"https://stripe-backend-woof.herokuapp.com/charge"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *body     = [NSString stringWithFormat:@"customerId=%@", customerId];
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data,
                                   NSURLResponse *response,
                                   NSError *error) {
                   
                   NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                   
                   NSLog(@"json: %@", jsonArray);
                   
                   if (!error) {
                       completion(YES, nil);
                   }
                   else {
                       completion(NO, error);
                   }
                   
                   
               }];
    [task resume];

    
}
- (void)deleteCardWithCardId:(NSString *)cardId andStripeId:(NSString *)stripeId completion:(void (^)(NSError *))completion {
    
    NSURL *url = [NSURL URLWithString:@"https://stripe-backend-woof.herokuapp.com/deletecard"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *body     = [NSString stringWithFormat:@"stripeId=%@&cardId=%@", stripeId, cardId];
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data,
                                   NSURLResponse *response,
                                   NSError *error) {
                   
                   if (!error) {
                       completion(nil);
                   }
                   else {
                       completion(error);
                   }
                   
                   
                   // neccessary?
                   //                   NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                   
                   
               }];
    [task resume];
    
}

#pragma mark -
#pragma mark Pets



- (void)getPetsWithCompletion:(void (^)(NSArray *, NSError *))completion {
    
    PFQuery *petQuery = [PFQuery queryWithClassName:@"Pet"];
    [petQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [petQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (!error) {
            
            NSMutableArray *pets = [[NSMutableArray alloc]init];
            
            for (PFObject *object in objects) {
                
                WoofPet *pet = [[WoofPet alloc]init];
                pet.name = object[@"name"];
                pet.objectId = object.objectId;
                
                [pets addObject:pet];
            }
            
            completion(pets, nil);
            
        }
        else {
            
        }
        
        
    }];
}


- (void)savePet:(WoofPet *)pet completion:(void (^)(BOOL, NSError *))completion {
    
    PFObject *petObject = [PFObject objectWithClassName:@"Pet"];
    petObject[@"name"] = pet.name;
    petObject[@"user"] = [PFUser currentUser];
    
    if (pet.objectId) {
        petObject.objectId = pet.objectId;
    }
    
    [petObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        completion(succeeded, error);
        
    }];
    
}





@end
