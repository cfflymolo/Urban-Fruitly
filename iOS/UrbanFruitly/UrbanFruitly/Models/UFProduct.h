//
//  UFProduct.h
//  UrbanFruitly
//
//  Created by Robert Colin on 6/1/13.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface UFProduct : NSObject

@property (strong, nonatomic) PFObject* pfObject;
@property (strong, nonatomic) NSString *productType;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *quantity;
@property (strong, nonatomic) NSDate *expirationDate;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) UIImage* image;

- (id)initWithProductyType:(NSString *)productType price:(NSNumber *)price quantity:(NSNumber*)quantity expirationDate:(NSDate *)expirationDate andDescription:(NSString *)description;

- (id)initWithPFObject:(PFObject*)obj;


@end
