//
//  UFUser.m
//  UrbanFruitly
//
//  Created by Robert Colin on 6/1/13.
//
//

#import "UFUser.h"

@implementation UFUser

- (id)initWithUsername:(NSString *)username password:(NSString *)password andEmailAddress:(NSString *)emailAddress
{
    if ((self = [super init])) {
        self.username = username;
        self.password = password;
        self.emailAddress = emailAddress;
    }
    
    return self;
}

@end
