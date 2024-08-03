//
//  Content.m
//  WildScan
//
//  Created by Shabir Jan on 09/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "Content.h"

@implementation Content

// Insert code here to add functionality to your managed object subclass
+(Content*)createContent:(NSString *)language contentType:(NSString *)type content:(NSString *)content moc:(NSManagedObjectContext *)moc{
    Content *content1 = [NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:moc];
    content1.contentBody = content;
    content1.contentType = type;
    content1.contentLanguage = language;
    [moc save:nil];
    
    return content1;

}
+(NSArray*)getAllContents:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Content"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setEntity:entity];
    
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
    return objects ;

}
+(Content*)getContent:(NSString *)lanaguage type:(NSString *)contentType moc:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Content"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(contentType == %@) && (contentLanguage == %@)",contentType,lanaguage];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
    return [objects firstObject];
}
+(void)deleteAllContent:(NSManagedObjectContext *)moc{
    
    NSArray *allObjs = [Content getAllContents:moc];
    for (Content *content in allObjs) {
        
        [moc deleteObject:content];
    }
    [moc save:nil];
}
@end
