//
//  FilterRecommendationsViewController.m
//  CampusFlow
//
//  Created by Ellie on 9/25/16.
//  Copyright © 2016 HackGT. All rights reserved.
//

#import "FilterRecommendationsViewController.h"

@interface FilterRecommendationsViewController ()

@end

@implementation FilterRecommendationsViewController

NSMutableData *connData;

static NSMutableArray *results;

+ (NSMutableArray*)getResults {
    return results;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onSubmit:(id)sender {
    NSMutableArray *params = [[NSMutableArray alloc] init];
    if (self.toggleSetting.selectedSegmentIndexes.count == 1) {
        if ([self.toggleSetting.selectedSegmentIndexes containsIndex:0]) {
            [params addObject:@"setting=indoor"];
        } else {
            [params addObject:@"setting=outdoor"];
        }
    }
    if (self.toggleLighting.selectedSegmentIndexes.count == 1 || self.toggleLighting.selectedSegmentIndexes.count == 2) {
        NSString *val = @"brightness=";
        if ([self.toggleLighting.selectedSegmentIndexes containsIndex:0]) {
            val = [NSString stringWithFormat:@"%@bright,", val];
        }
        if ([self.toggleLighting.selectedSegmentIndexes containsIndex:1]){
            val = [NSString stringWithFormat:@"%@medium,", val];
        }
        if ([self.toggleLighting.selectedSegmentIndexes containsIndex:2]){
            val = [NSString stringWithFormat:@"%@dark,", val];
        }
        val = [val substringToIndex:val.length - 1];
        [params addObject:val];
    }
    if (self.toggleTraffic.selectedSegmentIndexes.count == 1 || self.toggleTraffic.selectedSegmentIndexes.count == 2) {
        NSString *val = @"traffic=";
        if ([self.toggleTraffic.selectedSegmentIndexes containsIndex:0]) {
            val = [NSString stringWithFormat:@"%@high,", val];
        }
        if ([self.toggleTraffic.selectedSegmentIndexes containsIndex:1]){
            val = [NSString stringWithFormat:@"%@average,", val];
        }
        if ([self.toggleTraffic.selectedSegmentIndexes containsIndex:2]){
            val = [NSString stringWithFormat:@"%@empty,", val];
        }
        val = [val substringToIndex:val.length - 1];
        [params addObject:val];
    }
    if (self.toggleFood.selectedSegmentIndexes.count == 1) {
        if ([self.toggleFood.selectedSegmentIndexes containsIndex:0]) {
            [params addObject:@"food_nearby=shop/restaurant"];
        } else {
            [params addObject:@"food_nearby=vending"];
        }
    }
    if (self.toggleOutlets.selectedSegmentIndexes.count == 1) {
        if ([self.toggleOutlets.selectedSegmentIndexes containsIndex:0]) {
            [params addObject:@"outlets=many"];
        } else {
            [params addObject:@"outlets=few"];
        }
    }
    if (self.toggleTableSpace.selectedSegmentIndexes.count == 1) {
        if ([self.toggleTableSpace.selectedSegmentIndexes containsIndex:0]) {
            [params addObject:@"table_space=large"];
        } else {
            [params addObject:@"table_space=small"];
        }
    }
    
    NSString *query = @"";
    for (NSString *para in params) {
        query = [NSString stringWithFormat:@"%@%@&", query, para];
    }
    if (query.length > 0) {
        query = [query substringToIndex:query.length - 1];
    }
    
    connData = [[NSMutableData alloc] init];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ec2-54-149-183-223.us-west-2.compute.amazonaws.com/search.php?%@", query]];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:5];
    NSLog(@"Calling %@", url);
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:TRUE];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [connData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error = nil;
    NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:connData options:0 error:&error];
    results = [json mutableArrayValueForKey:@"result"];
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"viewRecRes"] animated:TRUE];
}
@end
