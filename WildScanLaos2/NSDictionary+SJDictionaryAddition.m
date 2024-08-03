//
//  NSDictionary+SJDictionaryAddition.m
//  WildScan
//
//  Created by Shabir Jan on 05/07/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "NSDictionary+SJDictionaryAddition.h"

@implementation NSDictionary (SJDictionaryAddition)
- (NSDictionary *)dictionaryByReplacingNullsWithStrings {
    const NSMutableDictionary *replaced = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for(NSString *key in self) {
        const id object = [self objectForKey:key];
        if(object == nul) {
            //pointer comparison is way faster than -isKindOfClass:
            //since [NSNull null] is a singleton, they'll all point to the same
            //location in memory.
            [replaced setObject:blank
                         forKey:key];
        }
    }
    
    return [replaced copy];
}
@end
