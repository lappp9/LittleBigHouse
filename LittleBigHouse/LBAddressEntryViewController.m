
#import "LBAddressEntryViewController.h"
#import "LBButtonFactory.h"
#import "LBLocationManager.h"
#import "HouseImagesViewController.h"
#import <FBShimmeringView.h>
#import "LBConnectivityMonitor.h"
#import <pop/POP.h>

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@interface UITextField (Extension)
- (CGRect)textRectForBounds:(CGRect)bounds;
- (CGRect)editingRectForBounds:(CGRect)bounds;
@end

@implementation UITextField (Extension)

- (CGRect)textRectForBounds:(CGRect)bounds;
{
    return CGRectInset( bounds , 10 , 10 );
}

- (CGRect)editingRectForBounds:(CGRect)bounds;
{
    return CGRectInset( bounds , 10 , 10 );
}

@end

@interface LBAddressEntryViewController ()
@property (nonatomic) UILabel *label;
@property (nonatomic) FBShimmeringView *labelShimmer;

@property (nonatomic) UIButton *nextButton;
@property (nonatomic) UITextField *streetOneTextField;
@property (nonatomic) UITextField *streetTwoTextField;
@property (nonatomic) UITextField *cityTextField;
@property (nonatomic) UITextField *stateTextField;
@property (nonatomic) UITextField *zipCodeTextField;

@property (nonatomic) UILabel *noInternetLabel;

@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;
@end

@implementation LBAddressEntryViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth  = [UIScreen mainScreen].bounds.size.width;
    
    if (![self navigationController]) {
        [self addDismissableNavBar];
    }
    
    self.navigationController.navigationBarHidden = NO;
    

    [self layoutLabel];
    
    [self layoutAddressFields];
    
    [self layoutNextButton];
    
    [self disableNextButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addGestureRecognizer:[UITapGestureRecognizer.alloc initWithTarget:self action:@selector(viewWasTapped:)]];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(noInternetConnection:) name:@"noInternetConnection" object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(internetConnection:) name:@"internetConnection" object:nil];
    
    if (!LBConnectivityMonitor.shared.connected) {
        [self noInternetConnection:nil];
    }
}

- (void)noInternetConnection:(NSNotification *)note;
{
    _noInternetLabel = [LBConnectivityMonitor.shared networkNotAvailableLabel];
    [self.view addSubview:_noInternetLabel];
    [self.view bringSubviewToFront:_noInternetLabel];
    _noInternetLabel.alpha = 1.0;
    _noInternetLabel.layer.zPosition = 1;
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(_screenWidth/2, _noInternetLabel.frame.size.height/2 + 50)];
    
    POPBasicAnimation *alphaAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnim.toValue = @(1.0);
    
    [_noInternetLabel pop_addAnimation:anim forKey:nil];
    [_noInternetLabel pop_addAnimation:alphaAnim forKey:nil];
}

- (void)internetConnection:(NSNotification *)note;
{
    if (_noInternetLabel && [self.view.subviews containsObject:_noInternetLabel]) {
        [_noInternetLabel removeFromSuperview];
    }
}

- (void)dismissWasTapped:(UIBarButtonItem *)backButton;
{
    for (UITextField *tf in @[_streetOneTextField, _streetTwoTextField, _cityTextField, _stateTextField, _zipCodeTextField]) {
        [tf resignFirstResponder];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWasTapped:(UITapGestureRecognizer *)tap;
{
    for (UITextField *tf in @[_streetOneTextField, _streetTwoTextField, _cityTextField, _stateTextField, _zipCodeTextField]) {
        [tf resignFirstResponder];
    }
}

- (BOOL)validateTextFields;
{
    if (!([_streetOneTextField.text isEqualToString:@""] ||
        [_cityTextField.text isEqualToString:@""] ||
        [_stateTextField.text isEqualToString:@""] ||
        [_zipCodeTextField.text isEqualToString:@""])) {
        [self enableNextButton];
        return YES;
    } else {
        [self disableNextButton];
        return NO;
    }
}

- (void)disableNextButton;
{
    _nextButton.alpha = 0.7;
    _nextButton.enabled = NO;
}

- (void)enableNextButton;
{
    _nextButton.alpha = 1.0;
    _nextButton.enabled = YES;
}

- (void)layoutLabel;
{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(16, 44 + 16 + 20, [UIScreen mainScreen].bounds.size.width - 32, 44)];
    _label.text = @"Enter an Address";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
    [self.view addSubview:_label];
}

- (void)layoutAddressFields;
{
    _streetOneTextField = [[UITextField alloc] init];
    _streetTwoTextField = [[UITextField alloc] init];
    _cityTextField      = [[UITextField alloc] init];
    _stateTextField     = [[UITextField alloc] init];
    _zipCodeTextField   = [[UITextField alloc] init];
    
    NSArray *textFields = @[_streetOneTextField, _streetTwoTextField, _cityTextField, _stateTextField, _zipCodeTextField];
    NSArray *placeholders = @[@"Street 1", @"Street 2", @"City", @"State", @"Zip Code"];
//    NSArray *nextResponders = @[_streetTwoTextField, _cityTextField, _stateTextField, _zipCodeTextField];
    
    for (NSInteger i = 0; i < textFields.count; i++) {
        UITextField *textField = textFields[i];
        UIReturnKeyType returnKey = (i == textFields.count -1) ? UIReturnKeyGo : UIReturnKeyNext;
        
        [self layoutAddressTextField:textField atPosition:i withPlaceholder:placeholders[i] andReturnKey:returnKey];
        
    }
}

- (void)layoutAddressTextField:(UITextField *)textField atPosition:(NSInteger)n withPlaceholder:(NSString *)placeholder andReturnKey:(UIReturnKeyType)returnKeyType;
{
    CGFloat yPosition = 44 + 16 + 20 + _label.frame.size.height + 16 + (8 * n) + (44 * n);

    textField.frame = CGRectMake(16, yPosition, [UIScreen mainScreen].bounds.size.width-32, 44);
    textField.placeholder = placeholder;
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 4;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.returnKeyType = UIReturnKeyDefault;
    textField.delegate = self;
    textField.returnKeyType = returnKeyType;
    textField.tag = n;
//    textField.nextResponder = nextResponder;
    
    [self.view addSubview:textField];
}

- (void)layoutNextButton;
{
    CGFloat yOrigin = [UIScreen mainScreen].bounds.size.height - 60 - 20;
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width - 32;
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _nextButton.frame = CGRectMake(16, yOrigin, buttonWidth, 60);
    _nextButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_nextButton setTitle: @"Next" forState:UIControlStateNormal];
    [LBButtonFactory blueStyleButton:_nextButton];
//    [LBButtonFactory ]
    
    [_nextButton addTarget:self action:@selector(nextButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_nextButton];
}

- (void)nextButtonWasTapped:(UIButton *)button;
{
    HouseImagesViewController *vc = [[HouseImagesViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_zipCodeTextField]) {
        [textField resignFirstResponder];
        if ([self validateTextFields]) {
            [_nextButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    } else {
        UIResponder* nextResponder = [textField.superview viewWithTag:textField.tag + 1];

        [nextResponder becomeFirstResponder];
    }
    
    [self validateTextFields];
    
    return YES;
}

- (void)addDismissableNavBar;
{
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, _screenWidth, 50)];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissWasTapped:)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Save Images"];
    item.leftBarButtonItem = backButton;
    [navbar setItems:@[item]];
    navbar.layer.zPosition = 2;
    
    [self.view addSubview:navbar];
}

- (BOOL)prefersStatusBarHidden;
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated;
{
    if ([self.view.subviews containsObject:_noInternetLabel]) {
        [_noInternetLabel removeFromSuperview];
    }
}
@end
