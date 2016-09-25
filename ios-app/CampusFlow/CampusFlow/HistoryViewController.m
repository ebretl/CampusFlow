//
//  SecondViewController.m
//  CampusFlow
//
//  Created by Ellie on 9/24/16.
//  Copyright © 2016 HackGT. All rights reserved.
//

#import "HistoryViewController.h"
#import "RecordObject.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    RecordObject *record = [RecordObject retrieveRecords][indexPath.row];
    [cell textLabel].text = record.location;
    [cell detailTextLabel].text = [NSString stringWithFormat:@"Rating: %i", (int)record.rating];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"rows: %@", [RecordObject retrieveRecords]);
    return [[RecordObject retrieveRecords] count];
}

@end
