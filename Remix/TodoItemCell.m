//
//  TodoItemCell.m
//  Remix
//
//  Created by Schiffer Li on 12/18/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import "TodoItemCell.h"
#import "Gobal.h"
#import "RNBlurModalView.h"
#import "TodoItem+Util.h"

@interface TodoItemCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *finishedBtn;

@end

@implementation TodoItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)radioBtn1Pressed:(UIButton*)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(todoItemCellDidRadioBtn1Pressed:)]) {
        [self.delegate todoItemCellDidRadioBtn1Pressed:self];
    }
    self.item.isFinished = !self.item.isFinished;
    sender.selected = self.item.isFinished;
    NSError *error = nil;
    if (![APP_DELEGATE.managedObjectContext save:&error]) {
        // Handle the error.
        [LOGGER trace:error];
    }
    
//    if (self.item.isFinished) {
//        RNBlurModalView *v = [[RNBlurModalView alloc] initWithTitle:@"Finished" message:@"恭喜您！这个任务您已经完成了！！！"];
//        v.dismissButtonRight = YES;
//        [v show];
//    }else{
//        RNBlurModalView *v = [[RNBlurModalView alloc] initWithTitle:@"Finished" message:@"这个任务已被你弄成未完成"];
//        v.dismissButtonRight = YES;
//        [v show];
//    }
}
- (IBAction)radioBtn2Pressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(todoItemCellDidRadioBtn2Pressed:)]) {
        [self.delegate todoItemCellDidRadioBtn2Pressed:self];
    }
}

-(void)setItem:(TodoItem *)item
{
    _item = item;
    _nameLabel.text = item.name;
    
    _dateLabel.text = [item timeRemainsOfDeadLine];
    self.finishedBtn.selected = item.isFinished;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
