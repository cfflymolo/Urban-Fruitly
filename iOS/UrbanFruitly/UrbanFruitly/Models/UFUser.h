//
//  UFUser.h
//  UrbanFruitly
//
//  Created by Robert Colin on 6/1/13.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface UFUser : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *emailAddress;

- (id)initWithUsername:(NSString *)username password:(NSString *)password andEmailAddress:(NSString *)emailAddress;

@end
