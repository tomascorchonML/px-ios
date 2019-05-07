//
//  MediosOffTableViewController.m
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Demian Tejo on 7/6/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

#import "MediosOffTableViewController.h"

#ifdef PX_PRIVATE_POD
    @import MercadoPagoSDKV4;
#else
    @import MercadoPagoSDK;
#endif

@implementation MediosOffTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableSet* conjunto = [[NSMutableSet alloc] init];
    [conjunto addObject:@"credit_card"];
    [conjunto addObject:@"debit_card"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MediosOffCell" forIndexPath:indexPath];
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"unwindFromOff" sender:self];
}


@end
