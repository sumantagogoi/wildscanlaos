//
//  SpeciesTranslation.h
//  WildScan
//
//  Created by Shabir Jan on 30/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Species;

NS_ASSUME_NONNULL_BEGIN

@interface SpeciesTranslation : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(void)createSpecieTranslation:(Species*)specieID  commonname:(NSString*)specieCommonName habitat:(NSString*)specieHabitat basicues:(NSString*)specieBasicIdCues consumeradvice:(NSString*)specieConsumerAdvice enforcementadvice:(NSString*)specieEnforcementAdvice similarAnimals:(NSString*)specieSimilarAnimals knownas:(NSString*)specieKnownAs averagesizeweight:(NSString*)specieAverageSizeWeight firstresponder:(NSString*)specieFirstResponder tradedas:(NSString*)specieTradedAs commontrafficing:(NSString*)specieCommonTrafficking notes:(NSString*)specieNotes  dieasename:(NSString*)specieDieaseName specieLangauge:(NSString*)specieLanguage moc:(NSManagedObjectContext*)moc;

+(NSArray*)getAllSpeciesTranslations:(NSString*)lanaguage moc:(NSManagedObjectContext*)moc;
+(SpeciesTranslation*)getSpecieTranslation:(Species*)species language:(NSString*)language moc:(NSManagedObjectContext*)moc;
@end

NS_ASSUME_NONNULL_END

#import "SpeciesTranslation+CoreDataProperties.h"
