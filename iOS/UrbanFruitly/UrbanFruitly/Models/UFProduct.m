//
//  UFProduct.m
//  UrbanFruitly
//
//  Created by Robert Colin on 6/1/13.
//
//

#import "UFProduct.h"

@interface UFProduct(){
    int imageLoadAttempts;
}

@end

@implementation UFProduct

+ (dispatch_queue_t)sharedQueue
{
    static dispatch_once_t pred;
    static dispatch_queue_t sharedDispatchQueue;
    
    dispatch_once(&pred, ^{
        sharedDispatchQueue = dispatch_queue_create("com.urbanfruitly.productQueue", NULL);
    });
    
    return sharedDispatchQueue;
}



//Designated Initializer
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
        
        imageLoadAttempts = 0;
    }
    
    return self;
}

- (id)initWithPFObject:(PFObject*)obj{
    if(!obj)
        return nil;
    if((self = [super init])){
        self.pfObject = obj;
        
        NSString* productType = [self.pfObject objectForKey:@"type"];
        NSNumber *price = [self.pfObject objectForKey:@"price"];
        NSNumber *quantity = [self.pfObject objectForKey:@"quantity"];
        NSDate* expirationDate = [NSDate date];
        NSString* description = [self.pfObject objectForKey:@"description"];
        
        self = [self initWithProductyType:productType price:price quantity:quantity expirationDate:expirationDate andDescription:description];
        
    }
    return self;
}

- (void) loadProductImageWithCompletionBlock:(void(^)(void))block{
    
    if(imageLoadAttempts>2){
        return;
    }
    
    //download image
    PFFile* imageFile = [self.pfObject objectForKey:@"image"];
    
    dispatch_async([UFProduct sharedQueue], ^{
        NSData* data = [imageFile getData];
        UIImage* image = [UIImage imageWithData:data];

        if(image==nil){
            NSLog(@"### IMAGE IS NIL!!");
        }
        
        assert(image);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imageLoadAttempts++;
            
            self.image = image;
            if(block)
                block();
        });
    });
}

@end
