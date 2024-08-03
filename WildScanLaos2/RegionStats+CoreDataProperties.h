//
//  RegionStats+CoreDataProperties.h
//  WildScan
//
//  Created by Shabir Jan on 15/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RegionStats.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegionStats (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *regionStatRID;
@property (nullable, nonatomic, retain) NSString *regionStatTotalSpecies;
@property (nullable, nonatomic, retain) NSString *regionStatTotalContacts;
@property (nullable, nonatomic, retain) NSString *regionStatTotalUsers;
@property (nullable, nonatomic, retain) NSNumber *regionIsDownloaded;

@end

NS_ASSUME_NONNULL_END
