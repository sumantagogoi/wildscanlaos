//
//  Contacts+CoreDataProperties.h
//  WildScan
//
//  Created by Shabir Jan on 11/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Contacts.h"
#import "ContactsTranslation.h"
NS_ASSUME_NONNULL_BEGIN

@interface Contacts (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *contactAddress1;
@property (nullable, nonatomic, retain) NSString *contactAddress2;
@property (nullable, nonatomic, retain) NSString *contactAgency;
@property (nullable, nonatomic, retain) NSString *contactAvailability;
@property (nullable, nonatomic, retain) NSString *contactAvatarUrl;
@property (nullable, nonatomic, retain) NSString *contactCity;
@property (nullable, nonatomic, retain) NSString *contactCountry;
@property (nullable, nonatomic, retain) NSString *contactCreatedBy;
@property (nullable, nonatomic, retain) NSString *contactCreatedDate;
@property (nullable, nonatomic, retain) NSString *contactEmail;
@property (nullable, nonatomic, retain) NSString *contactID;
@property (nullable, nonatomic, retain) NSString *contactJurisdicationScope;
@property (nullable, nonatomic, retain) NSString *contactLat;
@property (nullable, nonatomic, retain) NSString *contactLon;
@property (nullable, nonatomic, retain) NSString *contactName;
@property (nullable, nonatomic, retain) NSString *contactPhone;
@property (nullable, nonatomic, retain) NSString *contactRegion;
@property (nullable, nonatomic, retain) NSString *contactSpecialCapacityScope;
@property (nullable, nonatomic, retain) NSString *contactType;
@property (nullable, nonatomic, retain) NSString *contactUpdatedBy;
@property (nullable, nonatomic, retain) NSString *contactUpdatedDate;
@property (nullable, nonatomic, retain) NSString *contactUTM;
@property (nullable, nonatomic, retain) NSString *contactWebsite;
@property (nullable, nonatomic, retain) NSNumber *isContactFavorite;
@property (nullable, nonatomic, retain) NSNumber *contactSelectedForReport;
@property (nullable, nonatomic, retain) NSSet<ContactsTranslation *> *contactTranslation;

@end

@interface Contacts (CoreDataGeneratedAccessors)

- (void)addContactTranslationObject:(ContactsTranslation *)value;
- (void)removeContactTranslationObject:(ContactsTranslation *)value;
- (void)addContactTranslation:(NSSet<ContactsTranslation *> *)values;
- (void)removeContactTranslation:(NSSet<ContactsTranslation *> *)values;

@end

NS_ASSUME_NONNULL_END
