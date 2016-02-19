//
//  ViewController.m
//  EncryptionApp
//
//  Created by Arthur Pan on 2/16/16.
//  Copyright © 2016 Arthur Pan. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *RandomPrimeDisplay;
@property (nonatomic) BOOL *arrayOfPrimes;
@property int maxNumber;

@end

@implementation ViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil
                        bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        //Set the tab bar item's title
        self.tabBarItem.title = @"ViewC";
        
        //Create a UIImage from a file
        //This will use Hypno@2x.png on retina display devices
        //UIImage *image = [UIImage imageNamed:@"Hypno.png"];
        
        //Put that image on the tab bar item
        //self.tabBarItem.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.RandomPrimeDisplay.text = [NSString stringWithFormat:@"hello World"];
    
    // Do any additional setup after loading the view from its nib.
}

//Create all prime numbers before loading the screen
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _maxNumber = 100000; //hardcode this in depending on what you want
    
    _arrayOfPrimes = malloc(_maxNumber*sizeof(BOOL)); //allocate space for C-style array
    for (int i =0; i < _maxNumber; i++){
        _arrayOfPrimes[i] = YES;
        //NSLog(@"value of array[%d]: %d", i, _arrayOfPrimes[i]);
    }
    
    [self sieveOfEratosthenes:_maxNumber];
    
}

- (void)sieveOfEratosthenes:(int)maxNumber {
    //initialize 0 and 1 as false, assume that array is at least 2 ints long
    _arrayOfPrimes[0] = NO;
    _arrayOfPrimes[1] = NO;
    
    for (int j= 2; j < sqrt((double)maxNumber); j++){
        if (_arrayOfPrimes[j]==YES){
            for (int k = 0; j*j + k*j <= maxNumber; k++){
                _arrayOfPrimes[j*j + k*j] = NO;
            }
        }
    }
    NSLog(@"PRIMES UNDER %d: ", _maxNumber);
    NSMutableString *testString = [[NSMutableString alloc]init];
    NSString *tempString;
    for (int i =0; i < maxNumber; i++){
        if (_arrayOfPrimes[i] == YES){
            tempString = [NSString stringWithFormat:@"%d ", i];
            [testString appendString:tempString];
        }
    }
    NSLog(@"%@", testString);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
