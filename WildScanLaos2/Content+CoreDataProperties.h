//
//  Content+CoreDataProperties.h
//  WildScan
//
//  Created by Shabir Jan on 09/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Content.h"

NS_ASSUME_NONNULL_BEGIN

@interface Content (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *contentType;
@property (nullable, nonatomic, retain) NSString *contentLanguage;
@property (nullable, nonatomic, retain) NSString *contentCreatedBy;
@property (nullable, nonatomic, retain) NSString *contentCreatedDate;
@property (nullable, nonatomic, retain) NSString *contentBody;

@end

NS_ASSUME_NONNULL_END
