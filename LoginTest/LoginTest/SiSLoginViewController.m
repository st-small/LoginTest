//
//  SiSLoginViewController.m
//  LoginTest
//
//  Created by Stanly Shiyanovskiy on 05.03.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSLoginViewController.h"
#import "SiSLoginSuccessfully.h"

@interface SiSLoginViewController () 

@end

@implementation SiSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Check user defaults for registered users
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"registered"]) {
        NSLog(@"No user registered");
        self.loginBtn.hidden = YES;

    } else {
        
        NSLog(@"user is registered");
        self.reEnterPasswordFld.hidden = YES;
        self.registerBtn.hidden = YES;
    }

}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

#pragma mark - Actions

//Register user
- (IBAction)registerUser:(id)sender {
    
    //Check for full fields and show alert
    if ([self.usernameFld.text isEqualToString:@""] || [self.passwordFld.text isEqualToString:@""]) {
        
        UIAlertController* error = [UIAlertController alertControllerWithTitle:@"Oooops" message:@"You must complete all fields" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"ОК"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               
                                                               [self dismissViewControllerAnimated:YES completion:nil];
                                                               
                                                           }];
        
        [error addAction:okAction];
        
        [self presentViewController:error animated:YES completion:nil];
        
    } else {
        
        //Check password and re-Enter password fields
        [self checkPasswordsMatch];
    }
}

- (void) checkPasswordsMatch {
    
    if ([self.passwordFld.text isEqualToString:self.reEnterPasswordFld.text]) {
        NSLog(@"passwords match!");
        [self registerNewUser];
        
    } else {
        
        NSLog(@"passwords don't match");
        UIAlertController* error = [UIAlertController alertControllerWithTitle:@"Oooops" message:@"Your entered passwords do not match" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"ОК"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             [self dismissViewControllerAnimated:YES completion:nil];
                                                             
                                                         }];
        
        
        [error addAction:okAction];
        
        
        
        [self presentViewController:error animated:YES completion:nil];
    
    }
}

- (void) registerNewUser {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.usernameFld.text forKey:@"username"];
    [defaults setObject:self.passwordFld.text forKey:@"password"];
    [defaults setBool:YES forKey:@"registered"];
    
    [defaults synchronize];
    
    UIAlertController* success = [UIAlertController alertControllerWithTitle:@"Success" message:@"You have registered a new user" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"ОК"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [self openSuccessLoginView];
                                                         
                                                         
                                                     }];
    
    [success addAction:okAction];
    
    [self presentViewController:success animated:YES completion:nil];
    
}

- (IBAction)loginUser:(id)sender {
    
    NSUserDefaults* df = [NSUserDefaults standardUserDefaults];
    
    if ([self.usernameFld.text isEqualToString:[df objectForKey:@"username"]] && [self.passwordFld.text isEqualToString:[df objectForKey:@"password"]]) {
        NSLog(@"login credentials accepted");
        [self openSuccessLoginView];
        
        self.usernameFld.text = nil;
        self.passwordFld.text = nil;
        
    } else {
        
        NSLog(@"login credentials incorrect");
        UIAlertController* error = [UIAlertController alertControllerWithTitle:@"Oooops" message:@"Your username and password does not match" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"ОК"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             [self dismissViewControllerAnimated:YES completion:nil];
                                                             
                                                         }];
        
        
        [error addAction:okAction];
        [self presentViewController:error animated:YES completion:nil];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if ([textField isEqual:self.usernameFld]) {
        [self.passwordFld becomeFirstResponder];
    } else if ([textField isEqual:self.passwordFld] && !self.registerBtn.hidden) {
        [self.reEnterPasswordFld becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void) openSuccessLoginView {
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SiSLoginSuccessfully* vc = [sb instantiateViewControllerWithIdentifier:@"SiSLoginSuccessfully"];
    [self presentViewController:vc animated:YES completion:nil];
}









@end
