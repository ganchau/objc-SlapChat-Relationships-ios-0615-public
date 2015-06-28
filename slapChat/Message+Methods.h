//
//  Message+Methods.h
//  slapChat
//
//  Created by Gan Chau on 6/28/15.
//  Copyright (c) 2015 Joe Burgess. All rights reserved.
//

#import "Message.h"

@interface Message (Methods)

+(instancetype) messageWithContext:(NSManagedObjectContext *)context;

@end
