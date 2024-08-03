//
//  Region.h
//  WildScan
//
//  Created by Shabir Jan on 14/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Region : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(void)createRegion:(NSString*)rid code:(NSString*)rcode name:(NSString*)rname des:(NSString*)rdes email:(NSString*)remail moc:(NSManagedObjectContext*)moc;
+(NSArray*)getAllRegions:(NSManagedObjectContext*)moc;
+(Region*)getRegionByID:(NSString*)rid moc:(NSManagedObjectContext*)moc;
@end

NS_ASSUME_NONNULL_END

#import "Region+CoreDataProperties.h"
