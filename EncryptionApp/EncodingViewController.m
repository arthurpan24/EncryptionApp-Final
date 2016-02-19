//
//  EncodingViewController.m
//  EncryptionApp
//
//  Created by Arthur Pan on 2/17/16.
//  Copyright © 2016 Arthur Pan. All rights reserved.
//

#import "EncodingViewController.h"
#import "SieveOfEratosthenes.h"
#import <QuartzCore/QuartzCore.h>

#import "JKBigInteger.h" //Imported Library to handle big integers

#include <stdlib.h>

@interface EncodingViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userInput;
@property (weak, nonatomic) IBOutlet UILabel *key1;
@property (weak, nonatomic) IBOutlet UILabel *key2;
@property (weak, nonatomic) IBOutlet UILabel *privateKey;
@property (weak, nonatomic) IBOutlet UITextView *encodedText;
@property (weak, nonatomic) IBOutlet UIButton *generateButton;

- (IBAction)handleButtonClick:(id)sender;

//The variables used in RSA Encryption
@property int p;
@property int q;
@property int n;
@property int totient;
@property int d;
@property int e;

@end

@implementation EncodingViewController

int *arr; 
int numPrime;

//Receive array of primes and the number of primes for that array
- (void) initArrayOfPrimes:(int *)array withSize:(int)numberPrimes{
    arr = array;
    numPrime = numberPrimes;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        //Set the tab bar item's title
        self.tabBarItem.title = @"Encode";
        
         [self.view setBackgroundColor:[UIColor colorWithRed:0.32 green:0.32 blue:0.32 alpha:1.0]];

        //Create a UIImage from a file
        UIImage *image = [UIImage imageNamed:@"locksmall.png"];
        
        //Put that image on the tab bar item
        self.tabBarItem.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_userInput setDelegate:self];
    [_encodedText setDelegate:self];
    _userInput.layer.borderColor=[[UIColor redColor]CGColor];

    for (UIGestureRecognizer *recognizer in _encodedText.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]){
            recognizer.enabled = NO;
        }
    }
    
    //Initialize LongPressGesture so that user can select and copy all of encoded text
    UILongPressGestureRecognizer *LongPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(LongPressgesture:)];
    [_encodedText addGestureRecognizer:LongPressGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[_generateButton layer] setBorderWidth:1.0f];
    [[_generateButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    _generateButton.layer.cornerRadius = 10;
    _generateButton.clipsToBounds = YES;
    
    _userInput.placeholder = @"Encode this";
    _userInput.returnKeyType = UIReturnKeyDone;
}

//Generates the keys necessary for RSA Encryption
//Keys n and e are public keys
//Key d is a private key used to decrypt and RSA Encryption
- (void)generateKeys {
    _p = arr[arc4random_uniform((int)(numPrime-1)/2) + (int)(numPrime-1)/2]; //selects randomPrime from upper half of range
    _q = arr[arc4random_uniform((int)(numPrime-1)/2) + (int)(numPrime-1)/2]; //selects randomPrime from upper half of range
    _n = _p * _q;
    _totient = (_p-1)*(_q-1);
    _d = arr[arc4random_uniform((int)(numPrime-1)/2) + (int)(numPrime-1)/2]; //generate random privateKey
    _e = [self multiplicative_inverse:_d withMod:_totient];
}

//Implements Extended Euclid Algorithm to find the multiplicative inverse
//Credit to geeksforgeeks.com for implementation help
- (int)multiplicative_inverse:(int) a withMod:(int)b
{
    int b0 = b, t, q;
    int x0 = 0, x1 = 1;
    if (b == 1) return 1;
    while (a > 1) {
        q = a / b;
        t = b, b = a % b, a = t;
        t = x0, x0 = x1 - q * x0, x1 = t;
    }
    if (x1 < 0) x1 += b0;
    return x1;
}


//Recognizes if user presses and holds on text so that user can select all
- (void)LongPressgesture:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateEnded) {
        [_encodedText selectAll:self];
    }
}

//Function detects whether or not user is finished editing textField box
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//Function detects whether or not user is finished editing textView box
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//This function takes a string and encodes each character, displaying them with a space in between each code
- (void)encode {
    //if user input is not empty, encode
    if (![_userInput.text isEqual:@""]){
        NSMutableArray *inputString = [NSMutableArray array];
        
        NSString *str = _userInput.text;
        NSMutableString *returnString = [[NSMutableString alloc]init];
        
        JKBigInteger *mod_inverse = [[JKBigInteger alloc] initWithUnsignedLong:(unsigned long)_e];
        JKBigInteger *mod = [[JKBigInteger alloc] initWithUnsignedLong:(unsigned long)_n];
        
        //Loop through the input string, get each character, and encode it
        for (int i = 0; i < [str length]; i++) {
            [inputString addObject:[str substringWithRange:NSMakeRange(i, 1)]];
            NSString *string = inputString[i];
            JKBigInteger *item = [[JKBigInteger alloc] initWithUnsignedLong:(unsigned long)[string characterAtIndex:0]];
            [returnString appendString:[NSString stringWithFormat:@"%@ ",[item pow:mod_inverse andMod:mod]]];
        }
        _encodedText.text = returnString;
    }
}

- (void)setKeys {
    _key1.text = [NSString stringWithFormat:@"%d", _n];
    _key2.text = [NSString stringWithFormat:@"%d", _e];
    _privateKey.text = [NSString stringWithFormat:@"%d", _d];
}

//When button is pressed, execute encode
- (IBAction)handleButtonClick:(id)sender {
    [self setKeys];
    [self encode];
}

//Getters to send information to DecodingViewController
- (int)getN{
    return _n;
}

- (int)getD{
    return _d;
}

- (int)getE{
    return _e;
}

//For if we want to do exponentials fast with smaller numbers
//currently not used for the current implementation
- (int)binaryExponentiationBase:(int)x withPower:(int)n {
    if (n ==0)
        return 1;
    else if (n == 1)
        return x;
    else if (n%2 == 0)
        return [self binaryExponentiationBase:(x*x) withPower:(n/2)];
    else if (n%2 != 0)
        return [self binaryExponentiationBase:(x*x) withPower:((n-1)/2)];
    return -1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
