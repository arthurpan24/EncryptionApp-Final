//
//  SieveOfEratosthenes.m
//  EncryptionApp
//
//  Created by Arthur Pan on 2/17/16.
//  Copyright © 2016 Arthur Pan. All rights reserved.
//

#import "SieveOfEratosthenes.h"

@interface SieveOfEratosthenes()

@end

@implementation SieveOfEratosthenes

BOOL *arrayOfPrimes;
int maxNumber;
int *shortArrayOfPrimes;
int numberOfPrimes;

//Basic initializer, receives the max number possible that we want to find primes up to
- (id) initWithSize:(int)maxNumber {
    self = [super init];
    if (self) {
        [self initializeArrayOfPrimes:maxNumber];
    }
    return self;
}

//Initialize an array of boolean values that represent whether a number is a prime number or not
- (void) initializeArrayOfPrimes:(int)maxSize {
    maxNumber = maxSize;
    arrayOfPrimes = malloc(maxNumber*sizeof(BOOL)); //allocate space for C-style array
    
    for (int i =0; i < maxNumber; i++){
        arrayOfPrimes[i] = YES;
    }
    
    [self sieveOfEratosthenes:maxNumber];
    [self createShortArrayOfPrimes];
}

//The core function that implements the Sieve of Eratosthenes
- (void)sieveOfEratosthenes:(int)maxNumber {
    //initialize 0 and 1 as false, assume that array is at least 2 ints long
    arrayOfPrimes[0] = NO;
    arrayOfPrimes[1] = NO;
    
    for (int j= 2; j < sqrt((double)maxNumber); j++){
        if (arrayOfPrimes[j]==YES){
            for (int k = 0; j*j + k*j <= maxNumber; k++){
                arrayOfPrimes[j*j + k*j] = NO;
            }
        }
    }
}

//Take only the prime values and create an array of integers
- (void) createShortArrayOfPrimes {
    
    //Find out how many prime numbers there are in original list to allocate the right space for C-style array
    for (int i =0; i < maxNumber; i++){
        if (arrayOfPrimes[i] == YES){
            numberOfPrimes++;
        }
    }
    
    shortArrayOfPrimes = malloc(numberOfPrimes*sizeof(int)); //allocate space for C-style array
    
    int z = 0;
    for (int j=0; j < maxNumber; j++) {
        if (arrayOfPrimes[j] == YES){
            shortArrayOfPrimes[z] = j;
            z++;
        }
    }
    
    return;
}

//Getters to send to other classes
- (int) returnSize {
    return numberOfPrimes;
}

- (int *) returnShortArrayOfPrimes {
    return shortArrayOfPrimes;
}

@end
