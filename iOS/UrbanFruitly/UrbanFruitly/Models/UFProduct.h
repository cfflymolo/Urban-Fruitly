//
//  UFProduct.h
//  UrbanFruitly
//
//  Created by Robert Colin on 6/1/13.
//
//

#import <Foundation/Foundation.h>

@interface UFProduct : NSObject

@property (strong, nonatomic) NSString *productType;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSDate *expirationDate;
@property (strong, nonatomic) NSString *description;

- (id)initWithProductyType:(NSString *)productType price:(NSNumber *)price expirationDate:(NSDate *)expirationDate andDescription:(NSString *)description;

@end
