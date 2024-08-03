//
//  Species+CoreDataProperties.h
//  WildScan
//
//  Created by Shabir Jan on 20/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Species.h"
#import "SpeciesTranslation.h"
NS_ASSUME_NONNULL_BEGIN

@interface Species (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *specieAverageSizeWeight;
@property (nullable, nonatomic, retain) NSString *specieBasicIDCues;
@property (nullable, nonatomic, retain) NSString *specieCities;
@property (nullable, nonatomic, retain) NSString *specieCitiesOther;
@property (nullable, nonatomic, retain) NSString *specieCommonName;
@property (nullable, nonatomic, retain) NSString *specieCommonTrafficking;
@property (nullable, nonatomic, retain) NSString *specieConsumerAdvice;
@property (nullable, nonatomic, retain) NSString *specieCreatedBy;
@property (nullable, nonatomic, retain) NSString *specieCreatedDate;
@property (nullable, nonatomic, retain) NSString *specieDieaseName;
@property (nullable, nonatomic, retain) NSString *specieDieaseRiskLevel;
@property (nullable, nonatomic, retain) NSString *specieEnforcementAdvice;
@property (nullable, nonatomic, retain) NSString *specieExtantCountries;
@property (nullable, nonatomic, retain) NSString *specieFirstResponder;
@property (nullable, nonatomic, retain) NSString *specieHabitat;
@property (nullable, nonatomic, retain) NSString *specieID;
@property (nullable, nonatomic, retain) NSString *specieImageUrl;
@property (nullable, nonatomic, retain) NSNumber *specieIsFavorite;
@property (nullable, nonatomic, retain) NSString *specieIsGlobal;
@property (nullable, nonatomic, retain) NSNumber *specieIsImageDownloaded;
@property (nullable, nonatomic, retain) NSString *specieKeywordTags;
@property (nullable, nonatomic, retain) NSString *specieKnownAs;
@property (nullable, nonatomic, retain) NSString *specieNotes;
@property (nullable, nonatomic, retain) NSString *specieReferences;
@property (nullable, nonatomic, retain) NSString *specieRegion;
@property (nullable, nonatomic, retain) NSString *specieScientificName;
@property (nullable, nonatomic, retain) NSString *specieSimilarAnimals;
@property (nullable, nonatomic, retain) NSString *specieStatus;
@property (nullable, nonatomic, retain) NSString *specieTradedAs;
@property (nullable, nonatomic, retain) NSString *specieType;
@property (nullable, nonatomic, retain) NSString *specieUpdatedBy;
@property (nullable, nonatomic, retain) NSString *specieUpdatedDate;
@property (nullable, nonatomic, retain) NSString *specieWarnings;
@property (nullable, nonatomic, retain) NSSet<SpeciesTranslation *> *specieTranslation;

@end

@interface Species (CoreDataGeneratedAccessors)

- (void)addSpecieTranslationObject:(SpeciesTranslation *)value;
- (void)removeSpecieTranslationObject:(SpeciesTranslation *)value;
- (void)addSpecieTranslation:(NSSet<SpeciesTranslation *> *)values;
- (void)removeSpecieTranslation:(NSSet<SpeciesTranslation *> *)values;

@end

NS_ASSUME_NONNULL_END
