//
//  ViewController.m
//  QQ
//
//  Created by Yanice on 2017/1/17.
//  Copyright © 2017年 Yanice. All rights reserved.
//

#import "ViewController.h"

#import "ChatCell.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tabIV;
@property (weak, nonatomic) IBOutlet UITextField *eidtTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

static NSString *cellIdentifiter = @"cell";
@implementation ViewController {

    CGFloat _old_offSet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self.tabIV registerNib:[UINib nibWithNibName:@"ChatCell" bundle:nil] forCellReuseIdentifier:cellIdentifiter];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden) name:UIKeyboardWillHideNotification object:nil];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifiter];
    cell.text.text = [NSString stringWithFormat:@"第========%ld======",indexPath.row];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    _old_offSet = scrollView.contentOffset.y;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.y<_old_offSet) {
        [self.eidtTF resignFirstResponder];

    }else {
        if ((scrollView.contentSize.height-scrollView.contentOffset.y<=400)&&![self.eidtTF isFirstResponder]) {
            [self.eidtTF becomeFirstResponder];
        }
    }
}

- (void)keyBoardWillShow:(NSNotification *)not {

    NSDictionary *userInfo = [not userInfo];
    NSValue *value = userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect rect = value.CGRectValue;
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomConstraint.constant = [[UIScreen mainScreen] bounds].size.height-rect.origin.y;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.tabIV setContentOffset:CGPointMake(0, self.tabIV.contentSize.height-self.tabIV.frame.size.height) animated:YES];
    }];
}

- (void)keyBoardWillHidden {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomConstraint.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        _old_offSet = 0;
    }];
}
- (IBAction)sendAction:(UIButton *)sender {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
