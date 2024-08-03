//
//  ContactsTranslation.h
//  WildScan
//
//  Created by Shabir Jan on 28/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contacts;

NS_ASSUME_NONNULL_BEGIN

@interface ContactsTranslation : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(void)createContactTranslation:(Contacts*)contact language:(NSString*)contactLanguage name:(NSString*)contactName agency:(NSString*)contactAgency specailityNote:(NSString*)contactSpecailityNote address1:(NSString*)contactAddress1 address2:(NSString*)contactAddress2 city:(NSString*)contactCity moc:(NSManagedObjectContext*)moc;
+(NSArray*)getAllContactsWithTranslation:(NSString*)language moc:(NSManagedObjectContext*)moc;

+(ContactsTranslation*)getContactTranslationByID:(Contacts*)cid language:(NSString*)language moc:(NSManagedObjectContext*)moc;
+(NSArray*)getAll:(NSManagedObjectContext*)moc;

@end

NS_ASSUME_NONNULL_END

#import "ContactsTranslation+CoreDataProperties.h"
