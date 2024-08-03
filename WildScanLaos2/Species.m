//
//  Species.m
//  WildScan
//
//  Created by Shabir Jan on 16/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "Species.h"

@implementation Species

// Insert code here to add functionality to your managed object subclass
+(void)createSpecie:(NSString *)specieID region:(NSString *)specieRegion isGlobal:(NSString *)specieIsGlobal type:(NSString *)specieType commonname:(NSString *)specieCommonName scientificname:(NSString *)specieScientificName cities:(NSString *)specieCities citiesother:(NSString *)specieCitiesOther extantcountries:(NSString *)specieExtantCountries status:(NSString *)specieStatus warnings:(NSString *)specieWarnings habitat:(NSString *)specieHabitat basicues:(NSString *)specieBasicIdCues consumeradvice:(NSString *)specieConsumerAdvice enforcementadvice:(NSString *)specieEnforcementAdvice similarAnimals:(NSString *)specieSimilarAnimals knownas:(NSString *)specieKnownAs averagesizeweight:(NSString *)specieAverageSizeWeight firstresponder:(NSString *)specieFirstResponder tradedas:(NSString *)specieTradedAs commontrafficing:(NSString *)specieCommonTrafficking notes:(NSString *)specieNotes keywordtags:(NSString *)specieKeywordTags references:(NSString *)specieReferences dieasename:(NSString *)specieDieaseName dieaserisklevel:(NSString *)specieDieaseRiskLevel createdby:(NSString *)specieCreatedBy createddate:(NSString *)specieCreatedDate updatedby:(NSString *)specieUpdatedBy updateddate:(NSString *)specieUpdatedDate image:(NSString *)specieImage moc:(NSManagedObjectContext *)moc{
    Species *specie = [Species getSpecieByID:specieID moc:moc];
    if (specie == nil) {
        specie = [NSEntityDescription insertNewObjectForEntityForName:@"Species" inManagedObjectContext:moc];
    }
    
    specie.specieID = specieID;
    specie.specieRegion = specieRegion;
    specie.specieIsGlobal = specieIsGlobal;
    specie.specieType = specieType;
    specie.specieCommonName = specieCommonName;
    specie.specieScientificName = specieScientificName;
    specie.specieCities = specieCities;
    specie.specieCitiesOther = specieCitiesOther;
    specie.specieExtantCountries = specieExtantCountries;
    specie.specieStatus = specieStatus;
    specie.specieWarnings = specieWarnings;
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
    specie.specieKeywordTags = specieKeywordTags;
    specie.specieReferences = specieReferences;
    specie.specieDieaseName = specieDieaseName;
    specie.specieDieaseRiskLevel = specieDieaseRiskLevel;
    specie.specieCreatedBy = specieCreatedBy;
    specie.specieCreatedDate = specieCreatedDate;
    specie.specieUpdatedBy = specieUpdatedBy;
    specie.specieUpdatedDate = specieUpdatedDate;
    specie.specieEnforcementAdvice = specieEnforcementAdvice;
    specie.specieImageUrl = specieImage;
    specie.specieIsImageDownloaded = [NSNumber numberWithBool:YES];
    specie.specieIsFavorite = [NSNumber numberWithBool:NO];
    [moc save:nil];
    
    
}
+(NSArray*)getAllSpecieWithType:(NSString *)type moc:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Species"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"specieType == %@", type];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
   return objects;
}
+(Species*)getSpecieByID:(NSString *)specieID moc:(NSManagedObjectContext *)moc
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Species"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"specieID == %@", specieID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
    return [objects firstObject];
}
+(NSArray*)getAllFavoriteSpecies:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Species"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"specieIsFavorite == %@", [NSNumber numberWithBool:YES]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
    return objects;

}

+(NSArray*)getAllSpeciesImages:(NSManagedObjectContext *)moc{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"SpeciesImages"
											  inManagedObjectContext:moc];
	[fetchRequest setEntity:entity];
		//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"specieImageSpecieID == %@",specieID];
		//[fetchRequest setPredicate:predicate];
	NSError *error = nil;
	NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
	return objects;
	
}

+(NSArray*)getAllSpecies:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Species" inManagedObjectContext:moc];
    [fetchRequest setEntity:entityDesc];
    
    /*
    NSMutableString *query =[NSMutableString string];
    NSArray *regions = [[[NSUserDefaults standardUserDefaults]valueForKey:SELECTEDREGIONS] componentsSeparatedByString:@","];
    //query = [NSMutableString stringWithString:@"specieRegion == 0"];
    if (regions.count>0) {
        for (int i=0; i<regions.count; i++) {
            if (i==0) {
                query = [NSMutableString stringWithFormat:@"specieRegion == %@",[regions firstObject]];
            }else{
                [query appendString:[NSString stringWithFormat:@"OR specieRegion == %@",regions[i]]];
            }
        }
    }else{
        query = [NSMutableString stringWithFormat:@"specieRegion == %@",[regions firstObject]];
    }
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:query];
    [fetchRequest setPredicate:predicate];
    */
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"specieScientificName" ascending:YES selector:@selector(localizedCompare:)];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortByName, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    if (!error) {
        return objects;
    }else{
        return 0;
    }
}
@end
