//
//  Contacts.h
//  WildScan
//
//  Created by Shabir Jan on 14/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Contacts : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (void)createContact:(NSString*)contactID name:(NSString*)contactName avatar:(NSString*)contactImageUrl type:(NSString*)contactType agency:(NSString*)contactAgency jurisdiction:(NSString*)contactJurisdiction scapacity:(NSString*)contactSpecailCapacity email:(NSString*)contactEmail phone:(NSString*)contactPhone address1:(NSString*)contactAddress1 address2:(NSString*)contactAddress2 city:(NSString*)contactCity country:(NSString*)contactCountry region:(NSString*)contactRegion website:(NSString*)contactWebsite availability:(NSString*)contactAvailability lat:(NSString*)contactLat lon:(NSString*)contactLon utm:(NSString*)contactUTM createdBy:(NSString*)contactCreatedBy createdDate:(NSString*)contactCreatedDate updatedBy:(NSString*)contactUpdatedBy updatedDate:(NSString*)contactUpdatedDate moc:(NSManagedObjectContext*)moc;
+(NSArray*)getAllContacts:(NSManagedObjectContext*)moc;
+(NSArray*)getContactsForReport:(NSManagedObjectContext*)moc;
+(NSArray*)getAllFavoriteContacts:(NSManagedObjectContext*)moc;
+(NSArray*)getAllContactsForLanguage:(NSString*)language moc:(NSManagedObjectContext*)moc;
+(Contacts*)getContactByID:(NSString*)contactID moc:(NSManagedObjectContext*)moc;
@end

NS_ASSUME_NONNULL_END

#import "Contacts+CoreDataProperties.h"
