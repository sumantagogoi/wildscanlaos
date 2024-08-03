//
//  SpeciesTranslation+CoreDataProperties.h
//  WildScan
//
//  Created by Shabir Jan on 30/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SpeciesTranslation.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpeciesTranslation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *specieLanguage;
@property (nullable, nonatomic, retain) NSString *specieCommonName;
@property (nullable, nonatomic, retain) NSString *specieHabitat;
@property (nullable, nonatomic, retain) NSString *specieBasicIDCues;
@property (nullable, nonatomic, retain) NSString *specieConsumerAdvice;
@property (nullable, nonatomic, retain) NSString *specieEnforcementAdvice;
@property (nullable, nonatomic, retain) NSString *specieSimilarAnimals;
@property (nullable, nonatomic, retain) NSString *specieKnownAs;
@property (nullable, nonatomic, retain) NSString *specieAverageSizeWeight;
@property (nullable, nonatomic, retain) NSString *specieFirstResponder;
@property (nullable, nonatomic, retain) NSString *specieTradedAs;
@property (nullable, nonatomic, retain) NSString *specieCommonTrafficking;
@property (nullable, nonatomic, retain) NSString *specieNotes;
@property (nullable, nonatomic, retain) NSString *specieDieaseName;
@property (nullable, nonatomic, retain) Species *specieID;

@end

NS_ASSUME_NONNULL_END
