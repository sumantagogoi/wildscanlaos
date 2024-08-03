//
//  Species.h
//  WildScan
//
//  Created by Shabir Jan on 16/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Species : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(void)createSpecie:(NSString*)specieID region:(NSString*)specieRegion isGlobal:(NSString*)specieIsGlobal type:(NSString*)specieType commonname:(NSString*)specieCommonName scientificname:(NSString*)specieScientificName cities:(NSString*)specieCities citiesother:(NSString*)specieCitiesOther extantcountries:(NSString*)specieExtantCountries status:(NSString*)specieStatus warnings:(NSString*)specieWarnings habitat:(NSString*)specieHabitat basicues:(NSString*)specieBasicIdCues consumeradvice:(NSString*)specieConsumerAdvice enforcementadvice:(NSString*)specieEnforcementAdvice similarAnimals:(NSString*)specieSimilarAnimals knownas:(NSString*)specieKnownAs averagesizeweight:(NSString*)specieAverageSizeWeight firstresponder:(NSString*)specieFirstResponder tradedas:(NSString*)specieTradedAs commontrafficing:(NSString*)specieCommonTrafficking notes:(NSString*)specieNotes keywordtags:(NSString*)specieKeywordTags references:(NSString*)specieReferences dieasename:(NSString*)specieDieaseName dieaserisklevel:(NSString*)specieDieaseRiskLevel createdby:(NSString*)specieCreatedBy createddate:(NSString*)specieCreatedDate updatedby:(NSString*)specieUpdatedBy updateddate:(NSString*)specieUpdatedDate image:(NSString*)specieImage moc:(NSManagedObjectContext*)moc;
+(NSArray*)getAllSpecies:(NSManagedObjectContext*)moc;
+(Species*)getSpecieByID:(NSString*)specieID moc:(NSManagedObjectContext*)moc;
+(NSArray*)getAllFavoriteSpecies:(NSManagedObjectContext*)moc;
+(NSArray*)getAllSpeciesImages:(NSManagedObjectContext *)moc;
+(NSArray*)getAllSpecieWithType:(NSString*)type moc:(NSManagedObjectContext*)moc;
@end

NS_ASSUME_NONNULL_END

#import "Species+CoreDataProperties.h"
