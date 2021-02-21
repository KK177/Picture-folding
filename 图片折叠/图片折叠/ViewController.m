//
//  ViewController.m
//  图片折叠
//
//  Created by iiik- on 2021/2/21.
//

#import "ViewController.h"
#import "PicfoldingView.h"

@interface ViewController ()

@property (nonatomic, strong)PicfoldingView *picView;

@end

@implementation ViewController

- (PicfoldingView *)picView {
    if (!_picView) {
        _picView = [[PicfoldingView alloc]initWithFrame:CGRectMake(110, 200, 200, 200)];
    }
    return _picView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
}

- (void)setUI {
    
    [self.view addSubview:self.picView];
    
}
@end
