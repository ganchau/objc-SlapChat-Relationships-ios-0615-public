//
//  Message+Methods.m
//  slapChat
//
//  Created by Gan Chau on 6/28/15.
//  Copyright (c) 2015 Joe Burgess. All rights reserved.
//

#import "Message+Methods.h"

@implementation Message (Methods)

+(instancetype)messageWithContext:(NSManagedObjectContext *)context
{
    Message *newMessage = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:context];
    return newMessage;
}

@end
