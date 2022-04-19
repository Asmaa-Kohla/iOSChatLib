//
//  MailboxViewController.m
//  iOSChat
//
//  Created by Asmaa Kohla on 18/04/2022.
//

#import <Foundation/Foundation.h>
#import "MailboxViewController.h"

#import "MailboxCell.h"

@implementation MailboxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Mailbox";
}

#pragma mark - TableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MailboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MailboxCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"chatSegue" sender:nil];
    
}

@end
