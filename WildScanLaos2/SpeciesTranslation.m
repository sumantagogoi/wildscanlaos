//
//  SpeciesTranslation.m
//  WildScan
//
//  Created by Shabir Jan on 30/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "SpeciesTranslation.h"
#import "Species.h"

@implementation SpeciesTranslation

// Insert code here to add functionality to your managed object subclass
+(void)createSpecieTranslation:(Species *)specieID commonname:(NSString *)specieCommonName habitat:(NSString *)specieHabitat basicues:(NSString *)specieBasicIdCues consumeradvice:(NSString *)specieConsumerAdvice enforcementadvice:(NSString *)specieEnforcementAdvice similarAnimals:(NSString *)specieSimilarAnimals knownas:(NSString *)specieKnownAs averagesizeweight:(NSString *)specieAverageSizeWeight firstresponder:(NSString *)specieFirstResponder tradedas:(NSString *)specieTradedAs commontrafficing:(NSString *)specieCommonTrafficking notes:(NSString *)specieNotes dieasename:(NSString *)specieDieaseName specieLangauge:(NSString *)specieLanguage moc:(NSManagedObjectContext *)moc{
    
    
    
    SpeciesTranslation *specie = [SpeciesTranslation getSpecieTranslationByID:specieID language:specieLanguage moc:moc];
    if (specie == nil) {
        specie = [NSEntityDescription insertNewObjectForEntityForName:@"SpeciesTranslation" inManagedObjectContext:moc];
    }
    specie.specieID = specieID;
    
    specie.specieCommonName = specieCommonName;
    specie.specieHabitat = specieHabitat;
    specie.specieBasicIDCues = specieBasicIdCues;
    specie.specieConsumerAdvice = specieConsumerAdvice;
    specie.specieSimilarAnimals = specieSimilarAnimals;
    specie.specieKnownAs = specieKnownAs;
    specie.specieAverageSizeWeight = specieAverageSizeWeight;
    specie.specieFirstResponder = specieFirstResponder;
    specie.specieTradedAs = specieTradedAs;
    specie.specieCommonTrafficking = specieCommonTrafficking;
    specie.specieNotes = specieNotes;
    specie.specieLanguage = specieLanguage;
    specie.specieDieaseName = specieDieaseName;
    specie.specieEnforcementAdvice = specieEnforcementAdvice;
    [moc save:nil];

}
+(SpeciesTranslation*)getSpecieTranslation:(Species *)species language:(NSString *)language moc:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SpeciesTranslation"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"specieID == %@ AND specieLanguage==%@", species,language];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"specieCommonName" ascending:YES selector:@selector(localizedCompare:)];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortByName, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
    return [objects firstObject];

    return nil;
}
+(SpeciesTranslation*)getSpecieTranslationByID:(Species*)sid language:(NSString*)language moc:(NSManagedObjectContext*)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SpeciesTranslation"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"specieID == %@ AND specieLanguage==%@", sid,language];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
    return [objects firstObject];

}
+(NSArray*)getAllSpeciesTranslations:(NSString *)lanaguage moc:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SpeciesTranslation"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"specieLanguage == %@", lanaguage];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"specieCommonName" ascending:YES selector:@selector(localizedCompare:)];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortByName, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
    return objects;
}
@end
