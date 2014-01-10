//
//  TodoViewCellControllerViewController.m
//  Remix
//
//  Created by Schiffer Li on 12/17/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import "TodoViewCellController.h"
#import "NewTodoItemViewController.h"
#import "Gobal.h"
#import "TodoItemCell.h"

@interface TodoViewCellController ()<UITableViewDataSource,UITableViewDelegate,TodoItemCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *items;

@end

@implementation TodoViewCellController

-(void)viewDidLoad
{
    [super viewDidLoad];
    NSString *high = self.important ? @"很重要":@"不重要";
    NSString *urgency = self.urgency ? @"很紧急":@"不紧急";
    self.cellTitle.text = [NSString stringWithFormat:@"%@-%@",high,urgency];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TodoItem" inManagedObjectContext:APP_DELEGATE.managedObjectContext];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(important == %d) AND (urgency == %d)",self.important,self.urgency];
    [request setPredicate:predicate];

    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[APP_DELEGATE.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        [LOGGER trace:error];
    }
    self.items = mutableFetchResults;
    [self.tableView reloadData];
}

-(void)setBigView:(BOOL)bigView
{
    _bigView = bigView;
    [self.tableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodoItem *item = [_items objectAtIndex:indexPath.row];
    if (self.bigView) {
        TodoItemCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"MyCnmCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TodoItemCell" owner:self options:nil]objectAtIndex:0];
        }
        
        cell.item = item;

        return cell;
    }else{
        UITableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.textLabel.text = item.name;
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
}
//done item
-(void)todoItemCellDidRadioBtn1Pressed:(TodoItemCell *)cell
{

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.bigView?50:30;
}

-(void)todoItemCellDidRadioBtn2Pressed:(TodoItemCell *)cell
{
    NewTodoItemViewController *c = [NewTodoItemViewController new];
    c.item = cell.item;
    [ROOT_VC.naviController pushViewController:c animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}
@end
