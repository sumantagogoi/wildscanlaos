//
//  Region.m
//  WildScan
//
//  Created by Shabir Jan on 14/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "Region.h"

@implementation Region

// Insert code here to add functionality to your managed object subclass
+(void)createRegion:(NSString *)rid code:(NSString *)rcode name:(NSString *)rname des:(NSString *)rdes email:(NSString *)remail moc:(NSManagedObjectContext *)moc{

    Region *region = [NSEntityDescription insertNewObjectForEntityForName:@"Region" inManagedObjectContext:moc];
    region.regionID = rid;
    region.regionCode = rcode;
    region.regionName = rname;
    region.regionDescription = rdes;
    region.regionReportEmail = remail;
    
    [moc save:nil];
}
+(NSArray*)getAllRegions:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Region"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setEntity:entity];
    
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
    return objects ;
    
}
+(Region*)getRegionByID:(NSString *)rid moc:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Region"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"regionID == %@",rid];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
    return [objects firstObject] ;

    
}
@end
