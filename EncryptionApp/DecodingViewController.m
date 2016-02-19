//
//  DecodingViewController.m
//  EncryptionApp
//
//  Created by Arthur Pan on 2/17/16.
//  Copyright © 2016 Arthur Pan. All rights reserved.
//

#import "DecodingViewController.h"
#import "SieveOfEratosthenes.h"
#import <QuartzCore/QuartzCore.h>

#import "JKBigInteger.h" //Imported library to handle big integers

@interface DecodingViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputText;
@property (weak, nonatomic) IBOutlet UITextField *key1Input;
@property (weak, nonatomic) IBOutlet UITextField *key2Input;
@property (weak, nonatomic) IBOutlet UITextField *privateKeyInput;
@property (weak, nonatomic) IBOutlet UITextView *decodedText;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIButton *decodeButton;

- (IBAction)decodeButtonPressed:(id)sender;

//The important keys for decryption of a code
@property int e;
@property int d;
@property int n;

@end

@implementation DecodingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        //Set the tab bar item's title
        self.tabBarItem.title = @"Decode";
        
        [self.view setBackgroundColor:[UIColor colorWithRed:0.32 green:0.32 blue:0.32 alpha:1.0]];

        //Create a UIImage from a file
        //This will use Hypno@2x.png on retina display devices
        UIImage *image = [UIImage imageNamed:@"redlock.png"];
        
        //Put that image on the tab bar item
        self.tabBarItem.image = image;
    }
    return self;
}

//Receive the keys from EncodingViewController and set the important keys
-(void)initializeN:(int)n andE:(int)e andD:(int)d {
    _n = n;
    _e = e;
    _d = d;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_key1Input setDelegate:self];
    [_key2Input setDelegate:self];
    [_privateKeyInput setDelegate:self];
    [_decodedText setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[_decodeButton layer] setBorderWidth:1.0f];
    [[_decodeButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    _decodeButton.layer.cornerRadius = 10; 
    _decodeButton.clipsToBounds = YES;
    
    //Initialize the text boxes
    _inputText.placeholder = @"Decode this";
    _inputText.returnKeyType = UIReturnKeyDone;
    _inputText.delegate = self;
    
    _key1Input.placeholder = @"key1";
    _key1Input.returnKeyType = UIReturnKeyDone;
    _key1Input.delegate = self;
    
    _key2Input.placeholder = @"key2";
    _key2Input.returnKeyType = UIReturnKeyDone;
    _key2Input.delegate = self;
    
    _privateKeyInput.placeholder = @"private key";
    _privateKeyInput.returnKeyType = UIReturnKeyDone;
    _privateKeyInput.delegate = self;
    
    _decodedText.text = @"";
}

//When the user presses down, dismiss the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//When the user presses return, dismiss the keyboard
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)decode {
    NSMutableString *returnString = [[NSMutableString alloc]init];
    
    //Hold the values for n, e, and d keys in case they are overriden with a different set of keys
    int storeN = _n;
    int storeE = _e;
    int storeD = _d;
    
    //If any of the key inputs are left blank, use the default keys provided by EncodingViewController
    if ([[NSString stringWithFormat:@"%@", _key1Input.text] isEqual:@""]
        || [[NSString stringWithFormat:@"%@", _key2Input.text] isEqual:@""]
        || [[NSString stringWithFormat:@"%@", _privateKeyInput.text] isEqual:@""]){
        _message.text = @"Default keys used";
    }

    //If any of the key inputs are not the same as the default keys, use the new key inputs
    else if (![[NSString stringWithFormat:@"%@", _key1Input.text] isEqual:[NSString stringWithFormat:@"%d", _n]]
        || ![[NSString stringWithFormat:@"%@", _key2Input.text] isEqual:[NSString stringWithFormat:@"%d", _e]]
        || ![[NSString stringWithFormat:@"%@", _privateKeyInput.text] isEqual:[NSString stringWithFormat:@"%d", _d]]){
        
        _n = (int)[_key1Input.text integerValue];
        _e = (int)[_key2Input.text integerValue];
        _d = (int)[_privateKeyInput.text integerValue];
        _message.text = @"Custom keys used";
    }
    
    //If input text is not blank, decode the encoding
    if (![_inputText.text isEqual:@""]){
        
        //Split the input string into numbers by the spaces
        NSArray *words = [_inputText.text componentsSeparatedByString: @" "];
        NSMutableArray *mutableWords = [NSMutableArray arrayWithCapacity:[words count]];
        
        [mutableWords addObjectsFromArray:words];
        
        //Loop until the entire string has been parsed through
        for (int i =0; i < [mutableWords count]; i++){
            NSInteger b = [mutableWords[i] integerValue]; //Get the integer value of the number as a string
            
            JKBigInteger *mod = [[JKBigInteger alloc] initWithUnsignedLong:(unsigned long)_n];
            JKBigInteger *d = [[JKBigInteger alloc] initWithUnsignedLong:(unsigned long)_d];
            JKBigInteger *c = [[JKBigInteger alloc] initWithUnsignedLong:(unsigned long)b];
            
            //Decode using RSA Encryption
            b = [[NSString stringWithFormat:@"%@",[c pow:d andMod:mod]] integerValue];
            
            [returnString appendString:[NSString stringWithFormat:@"%c", (int)b]];
        }
    }
    
    //restore the values of n, e, and d to the default key values provided from EncodingViewController
    _n = storeN;
    _e = storeE;
    _d = storeD;
    
    _decodedText.text = returnString;
    
    return;
}

//When decode button is pressed, call decode function
- (IBAction)decodeButtonPressed:(id)sender {
    [self decode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
