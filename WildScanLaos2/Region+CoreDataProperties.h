//
//  Region+CoreDataProperties.h
//  WildScan
//
//  Created by Shabir Jan on 14/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Region.h"

NS_ASSUME_NONNULL_BEGIN

@interface Region (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *regionID;
@property (nullable, nonatomic, retain) NSString *regionCode;
@property (nullable, nonatomic, retain) NSString *regionName;
@property (nullable, nonatomic, retain) NSString *regionDescription;
@property (nullable, nonatomic, retain) NSString *regionReportEmail;

@end

NS_ASSUME_NONNULL_END
