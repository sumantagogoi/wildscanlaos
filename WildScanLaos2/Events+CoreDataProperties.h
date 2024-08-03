//
//  Events+CoreDataProperties.h
//  WildScan
//
//  Created by Shabir Jan on 10/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Events.h"

NS_ASSUME_NONNULL_BEGIN

@interface Events (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *eventCreatedBy;
@property (nullable, nonatomic, retain) NSString *eventCreatedDate;
@property (nullable, nonatomic, retain) NSString *eventDestinationAddress;
@property (nullable, nonatomic, retain) NSString *eventDestinationCountry;
@property (nullable, nonatomic, retain) NSString *eventDestinationLat;
@property (nullable, nonatomic, retain) NSString *eventDestinationLon;
@property (nullable, nonatomic, retain) NSString *eventID;
@property (nullable, nonatomic, retain) NSString *eventImageUrl;
@property (nullable, nonatomic, retain) NSString *eventIncident;
@property (nullable, nonatomic, retain) NSString *eventIncidentCondition;
@property (nullable, nonatomic, retain) NSString *eventIncidentDate;
@property (nullable, nonatomic, retain) NSString *eventInternetIncident;
@property (nullable, nonatomic, retain) NSString *eventLocationAddress;
@property (nullable, nonatomic, retain) NSString *eventLocationLat;
@property (nullable, nonatomic, retain) NSString *eventLocationLong;
@property (nullable, nonatomic, retain) NSString *eventMethod;
@property (nullable, nonatomic, retain) NSString *eventNumber;
@property (nullable, nonatomic, retain) NSString *eventNumberUnit;
@property (nullable, nonatomic, retain) NSString *eventOffenseDescription;
@property (nullable, nonatomic, retain) NSString *eventOffenseType;
@property (nullable, nonatomic, retain) NSString *eventOriginAddress;
@property (nullable, nonatomic, retain) NSString *eventOriginCountry;
@property (nullable, nonatomic, retain) NSString *eventOriginLat;
@property (nullable, nonatomic, retain) NSString *eventOriginLong;
@property (nullable, nonatomic, retain) NSString *eventRegion;
@property (nullable, nonatomic, retain) NSString *eventShareWith;
@property (nullable, nonatomic, retain) NSString *eventSpecies;
@property (nullable, nonatomic, retain) NSString *eventStatus;
@property (nullable, nonatomic, retain) NSString *eventSyndicate;
@property (nullable, nonatomic, retain) NSString *eventUpdatedBy;
@property (nullable, nonatomic, retain) NSString *eventUpdatedDate;
@property (nullable, nonatomic, retain) NSString *eventValueEstimatedUSD;
@property (nullable, nonatomic, retain) NSString *eventVehicleVesselDescription;
@property (nullable, nonatomic, retain) NSString *eventVehicleVesselLicenseNumber;
@property (nullable, nonatomic, retain) NSString *eventVesselName;
@property (nullable, nonatomic, retain) NSString *eventWebAddress;
@property (nullable, nonatomic, retain) NSString *eventCountry;
@property (nullable, nonatomic, retain) NSString *eventDateTime;

@end

NS_ASSUME_NONNULL_END
