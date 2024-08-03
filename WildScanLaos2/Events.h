//
//  Events.h
//  WildScan
//
//  Created by Shabir Jan on 09/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Events : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (void)createEvent:(NSString*)eventId incidentDate:(NSString*)eventIncidentDate internetIncident:(NSString*)eventInternetIncident locationAddress:(NSString*)eventLocationAddress webAddress:(NSString*)eventWebAddress locationLat:(NSString*)eventLocationLat locationLong:(NSString*)eventLocationLong region:(NSString*)eventRegion incident:(NSString*)eventIncident species:(NSString*)eventSpecies number:(NSString*)eventNumber numberUnit:(NSString*)eventNumberUnit incidentCondition:(NSString*)eventIncidentCondition offenseType:(NSString*)eventOffenseType offenseDescription:(NSString*)eventOffenseDescription method:(NSString*)eventMethod valueEstimatedUSD:(NSString*)eventValueEstimatedUSD originAddress:(NSString*)eventOriginAddress originCountry:(NSString*)eventOriginCountry originLat:(NSString*)eventOriginLat originLong:(NSString*)eventOriginLong destinationAddress:(NSString*)eventDestinationAddress destinationCountry:(NSString*)eventDestinationCountry destinationLat:(NSString*)eventDestiationLat destinationLong:(NSString*)eventDestinationLong vehicelVesselDescription:(NSString*)eventVehicelVesselDescription vehicleVesselLisenseNumber:(NSString*)eventVehicleVesselLisenseNumber vesselName:(NSString*)eventVesselName shareWith:(NSString*)eventShareWith syndicate:(NSString*)eventSyndicate status:(NSString*)eventStatus createdBy:(NSString*)eventCreatedBy createdDate:(NSString*)eventCreatedDate updatedBy:(NSString*)eventUpdatedBy updatedDate:(NSString*)eventUpdatedDate imageUrl:(NSString*)eventImageUrl country:(NSString*)eventCountry dateTime:(NSString*)dateTime moc:(NSManagedObjectContext*)moc;

+(NSArray*)getAllEvents:(NSManagedObjectContext*)moc;
+(Events*)getEventByID:(NSString*)eid moc:(NSManagedObjectContext*)moc;
+(void)deleteAllEvents:(NSManagedObjectContext*)moc;
@end

NS_ASSUME_NONNULL_END

#import "Events+CoreDataProperties.h"
