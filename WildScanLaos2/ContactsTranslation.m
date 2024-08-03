//
//  ContactsTranslation.m
//  WildScan
//
//  Created by Shabir Jan on 28/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "ContactsTranslation.h"
#import "Contacts.h"

@implementation ContactsTranslation

// Insert code here to add functionality to your managed object subclass
+(void)createContactTranslation:(Contacts *)contact language:(NSString *)contactLanguage name:(NSString *)contactName agency:(NSString *)contactAgency specailityNote:(NSString *)contactSpecailityNote address1:(NSString *)contactAddress1 address2:(NSString *)contactAddress2 city:(NSString *)contactCity moc:(NSManagedObjectContext *)moc{
    
    
    ContactsTranslation *contactTranslation =[ContactsTranslation getContactTranslationByID:contact language:contactLanguage moc:moc];
    
    
    if (contactTranslation == nil) {
        contactTranslation = [NSEntityDescription insertNewObjectForEntityForName:@"ContactsTranslation" inManagedObjectContext:moc];
    }
    contactTranslation.contactID = contact;
    contactTranslation.contactName = contactName;
    contactTranslation.contactLanguage = contactLanguage;
    contactTranslation.contactAgency = contactAgency;
    contactTranslation.contactAddress1 = contactAddress1;
    contactTranslation.contactAddress2 = contactAddress2;
    contactTranslation.contactCity = contactCity;
    contactTranslation.contactSpecailityNote = contactSpecailityNote;
    
    [moc save:nil];
}
+(NSArray*)getAll:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ContactsTranslation"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setEntity:entity];
    
   
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
    return objects;

}
+(NSArray*)getAllContactsWithTranslation:(NSString *)language moc:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ContactsTranslation"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contactLanguage == %@", language];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
    return objects;

}
+(ContactsTranslation*)getContactTranslationByID:(Contacts *)cid language:(NSString *)language  moc:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ContactsTranslation"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contactID == %@ AND contactLanguage==%@", cid,language];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
    return [objects firstObject];
}
@end
