//
//  User.m
//  twitter
//
//  Created by ezietz on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary { // instancetype: return the type of the class that you're calling it in (returns a User in this case)
    self = [super init]; // allows superclass to initialize and can return nil
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        
        // Initialize any other properties
    }
    return self;
}

@end
