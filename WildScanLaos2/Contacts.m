//
//  Contacts.m
//  WildScan
//
//  Created by Shabir Jan on 14/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "Contacts.h"

@implementation Contacts

// Insert code here to add functionality to your managed object subclass
+(void)createContact:(NSString *)contactID name:(NSString *)contactName avatar:(NSString *)contactImageUrl type:(NSString *)contactType agency:(NSString *)contactAgency jurisdiction:(NSString *)contactJurisdiction scapacity:(NSString *)contactSpecailCapacity email:(NSString *)contactEmail phone:(NSString *)contactPhone address1:(NSString *)contactAddress1 address2:(NSString *)contactAddress2 city:(NSString *)contactCity country:(NSString *)contactCountry region:(NSString *)contactRegion website:(NSString *)contactWebsite availability:(NSString *)contactAvailability lat:(NSString *)contactLat lon:(NSString *)contactLon utm:(NSString *)contactUTM createdBy:(NSString *)contactCreatedBy createdDate:(NSString *)contactCreatedDate updatedBy:(NSString *)contactUpdatedBy updatedDate:(NSString *)contactUpdatedDate moc:(NSManagedObjectContext *)moc{
    Contacts *contactObj = [Contacts getContactByID:contactID moc:moc];
    if (contactObj == nil) {
        contactObj = [NSEntityDescription insertNewObjectForEntityForName:@"Contacts" inManagedObjectContext:moc];
    }

    contactObj.contactID = contactID;
    contactObj.contactName = contactName;
    contactObj.contactAvatarUrl = contactImageUrl;
    contactObj.contactType = contactType;
    contactObj.contactAgency = contactAgency;
    contactObj.contactJurisdicationScope = contactJurisdiction;
    contactObj.contactSpecialCapacityScope = contactSpecailCapacity;
    contactObj.contactEmail = contactEmail;
    contactObj.contactPhone = contactPhone;
    contactObj.contactAddress1 = contactAddress1;
    contactObj.contactAddress2 = contactAddress2;
    contactObj.contactRegion = contactRegion;
    contactObj.contactCity = contactCity;
    contactObj.contactCountry = contactCountry;
    contactObj.contactWebsite = contactWebsite;
    contactObj.contactAvailability = contactAvailability;
    contactObj.contactLat = contactLat;
    contactObj.contactLon = contactLon;
    contactObj.contactUTM = contactUTM;
    contactObj.contactCreatedBy = contactCreatedBy;
    contactObj.contactCreatedDate = contactCreatedDate;
    contactObj.contactUpdatedBy = contactUpdatedBy;
    contactObj.contactUpdatedDate = contactUpdatedDate;
    contactObj.isContactFavorite = [NSNumber numberWithBool:NO];
    contactObj.contactSelectedForReport = [NSNumber numberWithBool:NO];
    
    
    
    [moc save:nil];
}
+(NSArray*)getContactsForReport:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contacts"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contactSelectedForReport == %@", [NSNumber numberWithBool:YES]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
    return objects;
}
+(Contacts*)getContactByID:(NSString *)contactID moc:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contacts"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setEntity:entity];
    
    
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contactID == %@", contactID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
    return [objects firstObject];
}
+(NSArray*)getAllContactsForLanguage:(NSString *)language moc:(NSManagedObjectContext *)moc{
    
    NSArray *objects = [self getAllContacts:moc];
    NSMutableArray *languageContacts = [NSMutableArray new];
    for (Contacts *contact in objects) {
        NSArray *contacts = [contact.contactTranslation allObjects];
        for (ContactsTranslation *translation in contacts) {
            if ([translation.contactLanguage isEqualToString:language]) {
                [languageContacts addObject:contact];
            }
        }
    }
    
    return objects;

}
+(NSArray*)getAllContacts:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contacts"
                                              inManagedObjectContext:moc];
    
    NSMutableString *query =[NSMutableString string];
     NSArray *regions = [[[NSUserDefaults standardUserDefaults]valueForKey:SELECTEDREGIONS] componentsSeparatedByString:@","];
    if (regions.count>1) {
        for (int i=0; i<regions.count; i++) {
            if (i==0) {
                query = [NSMutableString stringWithFormat:@"contactRegion == %@",[regions firstObject]];
            }else{
            [query appendString:[NSString stringWithFormat:@"OR contactRegion == %@",regions[i]]];
            }
        }
    }else{
        query = [NSMutableString stringWithFormat:@"contactRegion == %@",[regions firstObject]];
    }
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:query];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    NSSortDescriptor *sortName = [[NSSortDescriptor alloc] initWithKey:@"contactName" ascending:YES];
    NSSortDescriptor *sortCountry = [[NSSortDescriptor alloc] initWithKey:@"contactCountry" ascending:YES];
    //NSArray *sort = @[sortCountry, sortName];
    NSArray *sortedObjects = [objects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortCountry]];
    
    return sortedObjects;

}
+(NSArray*)getAllFavoriteContacts:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contacts"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isContactFavorite == %@", [NSNumber numberWithBool:YES]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
    return objects;

}
@end
