
#import "LBAddressEntryViewController.h"
#import "LBButtonFactory.h"
#import "LBLocationManager.h"
#import "HouseImagesViewController.h"
#import <FBShimmeringView.h>

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

@property (nonatomic) BOOL locationHasBeenFound;
@end

@implementation LBAddressEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self layoutLabel];
    
    [self layoutAddressFields];
    
    [self layoutNextButton];
    
    [self startShimmerIfNecessary];
    
    [self autoFillAddressIfNecessary];
    
    [self disableNextButton];
    
    _locationHasBeenFound = NO;
    
    [NSNotificationCenter.defaultCenter addObserverForName:kZipCodeWasSetNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        if (LBLocationManager.shared.deviceCity && !_locationHasBeenFound) {
            _locationHasBeenFound = YES;
            _labelShimmer.shimmering = NO;
            
            if (_shouldAutoFillAddress) {
                _cityTextField.text = [LBLocationManager.shared deviceCity];
                _stateTextField.text = [LBLocationManager.shared deviceState];
                _zipCodeTextField.text = [LBLocationManager.shared deviceZipCode];
                [self validateTextFields];
            }
        } else {
            NSLog(@"Still looking or already found");
        }
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)validateTextFields;
{
    if (!([_streetOneTextField.text isEqualToString:@""] ||
        [_cityTextField.text isEqualToString:@""] ||
        [_stateTextField.text isEqualToString:@""] ||
        [_zipCodeTextField.text isEqualToString:@""])) {
        [self enableNextButton];
    } else {
        [self disableNextButton];
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
    
    for (NSInteger i = 0; i < textFields.count; i++) {
        [self layoutAddressTextField:textFields[i] atPosition:i withPlaceholder:placeholders[i]];
    }
}

- (void)layoutAddressTextField:(UITextField *)textField atPosition:(NSInteger)n withPlaceholder:(NSString *)placeholder;
{
    CGFloat yPosition = 44 + 16 + 20 + _label.frame.size.height + 16 + (8 * n) + (44 * n);

    textField.frame = CGRectMake(16, yPosition, [UIScreen mainScreen].bounds.size.width-32, 44);
    textField.placeholder = placeholder;
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 4;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.returnKeyType = UIReturnKeyDefault;
    textField.delegate = self;
    
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
    [LBButtonFactory styleButton:_nextButton];
    
    [_nextButton addTarget:self action:@selector(nextButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_nextButton];
}

- (void)startShimmerIfNecessary;
{
    if (_shouldAutoFillAddress) {
        _labelShimmer = [[FBShimmeringView alloc] initWithFrame:_label.frame];
        
        [self.view addSubview:_labelShimmer];
        _labelShimmer.contentView = _label;
        _labelShimmer.shimmeringAnimationOpacity = 0.2;
        _labelShimmer.shimmeringSpeed = 150;
        _labelShimmer.shimmeringEndFadeDuration = 0.0;
        _labelShimmer.shimmeringPauseDuration = 0.0;
        _labelShimmer.shimmering = _shouldAutoFillAddress;
    }
}

- (void)autoFillAddressIfNecessary;
{
    if ([LBLocationManager.shared isAuthorized] && LBLocationManager.shared.deviceCity && _shouldAutoFillAddress) {
        _cityTextField.text = [LBLocationManager.shared deviceCity];
        _stateTextField.text = [LBLocationManager.shared deviceState];
        _zipCodeTextField.text = [LBLocationManager.shared deviceZipCode];
    }
}

- (void)nextButtonWasTapped:(UIButton *)button;
{
    HouseImagesViewController *vc = [[HouseImagesViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self validateTextFields];
    return YES;
}

@end
