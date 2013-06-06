//
//  UFProduct.m
//  UrbanFruitly
//
//  Created by Robert Colin on 6/1/13.
//
//

#import "UFProduct.h"

@interface UFProduct(){

}

@end

@implementation UFProduct

- (id)initWithProductyType:(NSString *)productType
                     price:(NSNumber *)price
                  quantity:(NSNumber *)quantity
            expirationDate:(NSDate *)expirationDate
            andDescription:(NSString *)description
{
    if ((self = [super init])) {
        self.productType = productType;
        self.price = price;
        self.quantity = quantity;
        self.expirationDate = expirationDate;
        self.description = description;
        self.image = nil;
    }
    
    return self;
}

- (id)initWithPFObject:(PFObject*)obj{
    if(!obj)
        return nil;
    if((self = [super init])){
        self.pfObject = obj;
        self.productType = [self.pfObject objectForKey:@"type"];
        self.price = [self.pfObject objectForKey:@"price"];
        self.quantity = [self.pfObject objectForKey:@"quantity"];
        self.expirationDate = [NSDate date];
        self.description = [self.pfObject objectForKey:@"description"];
    }
    return self;
}

@end
