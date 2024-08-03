//
//  UserReport+CoreDataProperties.h
//  WildScan
//
//  Created by Shabir Jan on 15/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserReport.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserReport (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userReportString;
@property (nullable, nonatomic, retain) NSNumber *userReportIsSubmitted;

@end

NS_ASSUME_NONNULL_END
