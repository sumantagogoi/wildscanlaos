//
//  ContactsTranslation+CoreDataProperties.h
//  WildScan
//
//  Created by Shabir Jan on 28/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ContactsTranslation.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactsTranslation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *contactLanguage;
@property (nullable, nonatomic, retain) NSString *contactName;
@property (nullable, nonatomic, retain) NSString *contactAgency;
@property (nullable, nonatomic, retain) NSString *contactSpecailityNote;
@property (nullable, nonatomic, retain) NSString *contactAddress1;
@property (nullable, nonatomic, retain) NSString *contactAddress2;
@property (nullable, nonatomic, retain) NSString *contactCity;
@property (nullable, nonatomic, retain) Contacts *contactID;

@end

NS_ASSUME_NONNULL_END
