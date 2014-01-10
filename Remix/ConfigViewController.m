//
//  ConfigViewController.m
//  Remix
//
//  Created by Schiffer Li on 1/6/14.
//  Copyright (c) 2014 Schiffer Li. All rights reserved.
//

#import "ConfigViewController.h"
#import "Gobal.h"
#import "RNBlurModalView.h"
#import "XAlertView.h"

@interface ConfigViewController ()

@property(strong,nonatomic) NSArray *section1Ary;
@property(strong,nonatomic) NSArray *section2Ary;

@end

@implementation ConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)toggleLeftNavi:(id)sender {
    [ROOT_VC toggleLeftNavigationBar];
}
- (IBAction)clearAllItems:(id)sender {
    [XAlertView showConfirm:@"确认" subTitle:@"您确定要删除所有的事项吗？？？" okBtnText:@"OK" cancelBtnText:@"Cancel" completion:^(NSUInteger buttonIndex) {
        if (buttonIndex) {
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"TodoItem" inManagedObjectContext:APP_DELEGATE.managedObjectContext];
            [request setEntity:entity];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            [request setSortDescriptors:sortDescriptors];

            NSError *error = nil;
            NSMutableArray *mutableFetchResults = [[APP_DELEGATE.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
            if (mutableFetchResults == nil) {
                [LOGGER trace:error];
            }
            [mutableFetchResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [APP_DELEGATE.managedObjectContext deleteObject:obj];
                // Commit the change.
                NSError *error = nil;
                if (![APP_DELEGATE.managedObjectContext save:&error]) {
                    // Handle the error.
                    [LOGGER trace:error];
                }
            }];
            RNBlurModalView *blur = [[RNBlurModalView alloc] initWithTitle:@"这下好" message:@"一个事项都没了~~~"];
            [blur show];
        }
    }];
}
- (IBAction)suggestionFeedBack:(id)sender {
    RNBlurModalView *blur = [[RNBlurModalView alloc] initWithTitle:@"意见反馈" message:@"如有意见或者建议请发送至邮箱zhlovee@gmail.com,感谢支持！！！"];
    [blur show];
}
- (IBAction)bugReport:(id)sender {
    RNBlurModalView *blur = [[RNBlurModalView alloc] initWithTitle:@"BUG？" message:@"如发现bug请不要宣扬，发送至zhlovee@gmail.com，感谢支持！！！"];
    [blur show];
}
- (IBAction)checkupdate:(id)sender {
    RNBlurModalView *blur = [[RNBlurModalView alloc] initWithTitle:@"UPDATE" message:@"没错您现在用的就是最新版本！！"];
    [blur show];
}
- (IBAction)tujianAPP:(id)sender {
    RNBlurModalView *blur = [[RNBlurModalView alloc] initWithTitle:@"WANT MORE？？" message:@"更多精彩应用请关注本人腾讯微博@zhLovEe,感谢支持"];
    [blur show];
}
- (IBAction)hezuo:(id)sender {
    RNBlurModalView *blur = [[RNBlurModalView alloc] initWithTitle:@"合作？" message:@"如寻求项目合作请发送邮件至zhlovee@gmail.com，谢谢！"];
    [blur show];
}
- (IBAction)about:(id)sender {
    RNBlurModalView *blur = [[RNBlurModalView alloc] initWithTitle:@"About" message:@"本项目UI设计基本模仿安卓版advanced TodoList实现，关于原作信息请访问:\nhttp://www.ezdo.cn/ \n另外项目已开源：\nhttps://github.com/zhlovee/RemixTodoList\n感谢支持"];
    [blur show];
}

@end
