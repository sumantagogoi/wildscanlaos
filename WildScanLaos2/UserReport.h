//
//  UserReport.h
//  WildScan
//
//  Created by Shabir Jan on 15/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserReport : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(void)createUserReport:(NSString*)reportString moc:(NSManagedObjectContext*)moc;
+(NSArray*)getAllUnsubmittedReports:(NSManagedObjectContext*)moc;
@end

NS_ASSUME_NONNULL_END

#import "UserReport+CoreDataProperties.h"
