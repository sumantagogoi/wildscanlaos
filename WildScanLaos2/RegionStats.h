//
//  RegionStats.h
//  WildScan
//
//  Created by Shabir Jan on 15/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegionStats : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(void)createRegionStat:(NSString*)rid tspecies:(NSString*)totalSpecies tcontacts:(NSString*)totalContacts tusers:(NSString*)totalUsers moc:(NSManagedObjectContext*)moc;
+(NSArray*)getAllRegionStats:(NSManagedObjectContext*)moc;
+(RegionStats*)getRegionStatForID:(NSString*)rid moc:(NSManagedObjectContext*)moc;
@end

NS_ASSUME_NONNULL_END

#import "RegionStats+CoreDataProperties.h"
