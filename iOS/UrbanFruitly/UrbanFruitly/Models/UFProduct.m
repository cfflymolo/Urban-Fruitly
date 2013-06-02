//
//  UFProduct.m
//  UrbanFruitly
//
//  Created by Robert Colin on 6/1/13.
//
//

#import "UFProduct.h"

@implementation UFProduct

- (id)initWithProductyType:(NSString *)productType
                     price:(NSNumber *)price
            expirationDate:(NSDate *)expirationDate
            andDescription:(NSString *)description
{
    if ((self = [super init])) {
        self.productType = productType;
        self.price = price;
        self.expirationDate = expirationDate;
        self.description = description;
    }
    
    return self;
}

@end
