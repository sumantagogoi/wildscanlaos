//
//  Events.m
//  WildScan
//
//  Created by Shabir Jan on 09/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "Events.h"

@implementation Events

// Insert code here to add functionality to your managed object subclass
+(void)createEvent:(NSString *)eventId incidentDate:(NSString *)eventIncidentDate internetIncident:(NSString *)eventInternetIncident locationAddress:(NSString *)eventLocationAddress webAddress:(NSString *)eventWebAddress locationLat:(NSString *)eventLocationLat locationLong:(NSString *)eventLocationLong region:(NSString *)eventRegion incident:(NSString *)eventIncident species:(NSString *)eventSpecies number:(NSString *)eventNumber numberUnit:(NSString *)eventNumberUnit incidentCondition:(NSString *)eventIncidentCondition offenseType:(NSString *)eventOffenseType offenseDescription:(NSString *)eventOffenseDescription method:(NSString *)eventMethod valueEstimatedUSD:(NSString *)eventValueEstimatedUSD originAddress:(NSString *)eventOriginAddress originCountry:(NSString *)eventOriginCountry originLat:(NSString *)eventOriginLat originLong:(NSString *)eventOriginLong destinationAddress:(NSString *)eventDestinationAddress destinationCountry:(NSString *)eventDestinationCountry destinationLat:(NSString *)eventDestiationLat destinationLong:(NSString *)eventDestinationLong vehicelVesselDescription:(NSString *)eventVehicelVesselDescription vehicleVesselLisenseNumber:(NSString *)eventVehicleVesselLisenseNumber vesselName:(NSString *)eventVesselName shareWith:(NSString *)eventShareWith syndicate:(NSString *)eventSyndicate status:(NSString *)eventStatus createdBy:(NSString *)eventCreatedBy createdDate:(NSString *)eventCreatedDate updatedBy:(NSString *)eventUpdatedBy updatedDate:(NSString *)eventUpdatedDate imageUrl:(NSString *)eventImageUrl country:(NSString *)eventCountry dateTime:(NSString *)dateTime moc:(NSManagedObjectContext *)moc{
    Events *event = [Events getEventByID:eventId moc:moc];
    if (event == nil) {
        event = [NSEntityDescription insertNewObjectForEntityForName:@"Events" inManagedObjectContext:moc];
    }
    event.eventID = eventId;
    event.eventIncidentDate = eventIncidentDate;
    event.eventInternetIncident = eventInternetIncident;
    event.eventLocationAddress = eventLocationAddress;
    event.eventWebAddress = eventWebAddress;
    event.eventLocationLat = eventLocationLat;
    event.eventLocationLong = eventLocationLong;
    event.eventRegion = eventRegion;
    event.eventIncident = eventIncident;
    event.eventSpecies = eventSpecies;
    event.eventNumber = eventNumber;
    event.eventNumberUnit = eventNumberUnit;
    event.eventIncidentCondition = eventIncidentCondition;
    event.eventOffenseType = eventOffenseType;
    event.eventOffenseDescription = eventOffenseDescription;
    event.eventMethod = eventMethod;
    event.eventValueEstimatedUSD = eventValueEstimatedUSD;
    event.eventOriginAddress = eventOriginAddress;
    event.eventOriginCountry = eventOriginCountry;
    event.eventOriginLat = eventOriginLat;
    event.eventOriginLong = eventOriginLong;
    event.eventDestinationAddress = eventDestinationAddress;
    event.eventDestinationCountry = eventDestinationCountry;
    event.eventDestinationLat = eventDestiationLat;
    event.eventDestinationLon = eventDestinationLong;
    event.eventVehicleVesselDescription = eventVehicelVesselDescription;
    event.eventVehicleVesselLicenseNumber = eventVehicleVesselLisenseNumber;
    event.eventVesselName = eventVesselName;
    event.eventShareWith = eventShareWith;
    event.eventSyndicate = eventSyndicate;
    event.eventStatus = eventStatus;
    event.eventCreatedBy = eventCreatedBy;
    event.eventCreatedDate = eventCreatedDate;
    event.eventUpdatedBy = eventUpdatedBy;
    event.eventUpdatedDate = eventUpdatedDate;
    event.eventImageUrl = eventImageUrl;
    event.eventCountry = eventCountry;
    event.eventDateTime = dateTime;
    [moc save:nil];
}
+(NSArray*)getAllEvents:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Events" inManagedObjectContext:moc];
    [fetchRequest setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    if (!error) {
        return objects;
    }else{
        return 0;
    }

}
+(Events*)getEventByID:(NSString*)eid moc:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Events" inManagedObjectContext:moc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventID == %@",eid];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    if (!error) {
        return [objects firstObject];
    }else{
        return 0;
    }
}
+(void)deleteAllEvents:(NSManagedObjectContext *)moc{
    NSArray *allObjs = [Events getAllEvents :moc];
    for (Events *content in allObjs) {
        
        [moc deleteObject:content];
    }
    [moc save:nil];
}
@end
