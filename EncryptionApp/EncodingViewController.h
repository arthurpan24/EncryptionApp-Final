//
//  EncodingViewController.h
//  EncryptionApp
//
//  Created by Arthur Pan on 2/17/16.
//  Copyright © 2016 Arthur Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EncodingViewController : UIViewController

- (void)initArrayOfPrimes:(int *)array withSize:(int)numberPrimes;
- (void)generateKeys;
- (int)multiplicative_inverse:(int) a withMod:(int)b;
- (int)binaryExponentiationBase:(int)x withPower:(int)n;
- (int)getN;
- (int)getD;
- (int)getE;

@end
