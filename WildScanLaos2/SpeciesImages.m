//
//  SpeciesImages.m
//  WildScan
//
//  Created by Shabir Jan on 01/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "SpeciesImages.h"
#import "Species.h"

@implementation SpeciesImages

// Insert code here to add functionality to your managed object subclass
+(void)createSpecieImage:(NSString *)specie imagePath:(NSString *)imagePath credit:(NSString *)imageCredit order:(NSString *)imageOrder licence:(NSString *)imageLicence moc:(NSManagedObjectContext *)moc{
    SpeciesImages *species = [NSEntityDescription insertNewObjectForEntityForName:@"SpeciesImages" inManagedObjectContext:moc];;

    
    
    species.specieImageSpecieID = specie;
    
    species.specieImagePath = imagePath;
    species.specieImageOrder = imageOrder;
    species.specieImageLicence = imageLicence;
    species.specieImageCredit = imageCredit;
    
    [moc save:nil];

}
+(SpeciesImages*)getImage:(NSString *)imageName moc:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SpeciesImages"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"specieImagePath == %@",imageName];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
    return [objects firstObject];
}
+(NSArray*)getAllSpecieImages:(NSString*)specieID moc:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SpeciesImages"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"specieImageSpecieID == %@",specieID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
	
	NSLog(@"%@shan",objects);
    
    return objects;

}
@end
