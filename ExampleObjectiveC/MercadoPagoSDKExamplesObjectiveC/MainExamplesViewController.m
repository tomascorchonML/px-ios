//
//  MainExamplesViewController.m
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 1/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

#import "MainExamplesViewController.h"
#import "ExampleUtils.h"

#import "MercadoPagoSDKExamplesObjectiveC-Swift.h"
#import "PaymentMethodPluginConfigViewController.h"
#import "PaymentPluginViewController.h"
#import "MLMyMPPXTrackListener.h"

#ifdef PX_PRIVATE_POD
    @import MercadoPagoSDKV4;
#else
    @import MercadoPagoSDK;
#endif

@implementation MainExamplesViewController

- (IBAction)checkoutFlow:(id)sender {

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.opaque = YES;

    self.pref = nil;

    [self setCheckoutPref_CreditCardNotExcluded];
    [self setCheckoutPrefAdditionalInfo];

    self.checkoutBuilder = [[MercadoPagoCheckoutBuilder alloc] initWithPublicKey:@"APP_USR-ba2e6b8c-8b6d-4fc3-8a47-0ab241d0dba4" checkoutPreference:self.pref paymentConfiguration:[self getPaymentConfiguration]];

    NSDictionary *dict = @{ @"key" : @"value"};

    [PXTracker setListener:self flowName:@"instore" flowDetails:dict];

    [self.checkoutBuilder setPrivateKeyWithKey:@"APP_USR-6519316523937252-070516-964fafa7e2c91a2c740155fcb5474280__LA_LD__-261748045"];

    // AdvancedConfig
    PXAdvancedConfiguration* advancedConfig = [[PXAdvancedConfiguration alloc] init];
    [advancedConfig setExpressEnabled:YES];

    PXDiscountParamsConfiguration* disca = [[PXDiscountParamsConfiguration alloc] initWithLabels:[NSArray arrayWithObjects: @"1", @"2", nil] productId:@"test_product_id"];
    [advancedConfig setDiscountParamsConfiguration: disca];

    // Add theme to advanced config.
    MeliTheme *meliTheme = [[MeliTheme alloc] init];
    [advancedConfig setTheme:meliTheme];

    // Add ReviewConfirm configuration to advanced config.
    [advancedConfig setReviewConfirmConfiguration: [self getReviewScreenConfiguration]];

    // Add ReviewConfirm Dynamic views configuration to advanced config.
    [advancedConfig setReviewConfirmDynamicViewsConfiguration:[self getReviewScreenDynamicViewsConfigurationObject]];

    // Add ReviewConfirm Dynamic View Controller configuration to advanced config.
    TestComponent *dynamicViewControllersConfigObject = [self getReviewScreenDynamicViewControllerConfigurationObject];
    [advancedConfig setDynamicViewControllersConfiguration: [NSArray arrayWithObjects: dynamicViewControllersConfigObject, nil]];
    [advancedConfig setReviewConfirmDynamicViewsConfiguration:[self getReviewScreenDynamicViewsConfigurationObject]];

    // Add PaymentResult configuration to advanced config.
    [advancedConfig setPaymentResultConfiguration: [self getPaymentResultConfiguration]];

    // Disable bank deals
    //[advancedConfig setBankDealsEnabled:NO];

    // Set advanced comnfig
    [self.checkoutBuilder setAdvancedConfigurationWithConfig:advancedConfig];

    [self.checkoutBuilder setLanguage:@"es"];
  
    MercadoPagoCheckout *mpCheckout = [[MercadoPagoCheckout alloc] initWithBuilder:self.checkoutBuilder];

    //[mpCheckout startWithLazyInitProtocol:self];
    [mpCheckout startWithLazyInitProtocol:self];
}

// ReviewConfirm
-(PXReviewConfirmConfiguration *)getReviewScreenConfiguration {
    PXReviewConfirmConfiguration *config = [TestComponent getReviewConfirmConfiguration];
    return config;
}

// ReviewConfirm Dynamic Views Configuration Object
-(TestComponent *)getReviewScreenDynamicViewsConfigurationObject {
    TestComponent *config = [TestComponent getReviewConfirmDynamicViewsConfiguration];
    return config;
}

// ReviewConfirm Dynamic View Controller Configuration Object
-(TestComponent *)getReviewScreenDynamicViewControllerConfigurationObject {
    TestComponent *config = [TestComponent getReviewConfirmDynamicViewControllerConfiguration];
    return config;
}


// PaymentResult
-(PXPaymentResultConfiguration *)getPaymentResultConfiguration {
    PXPaymentResultConfiguration *config = [TestComponent getPaymentResultConfiguration];
    return config;
}

// Procesadora
-(PXPaymentConfiguration *)getPaymentConfiguration {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"PaymentMethodPlugins" bundle:[NSBundle mainBundle]];
    PaymentPluginViewController *paymentProcessorPlugin = [storyboard instantiateViewControllerWithIdentifier:@"paymentPlugin"];
    self.paymentConfig = [[PXPaymentConfiguration alloc] initWithSplitPaymentProcessor:paymentProcessorPlugin];
    [self addPaymentMethodPluginToPaymentConfig];
    [self addCharges];
    return self.paymentConfig;
}

-(void)addPaymentMethodPluginToPaymentConfig {

    PXPaymentMethodPlugin * bitcoinPaymentMethodPlugin = [[PXPaymentMethodPlugin alloc] initWithPaymentMethodPluginId:@"account_money" name:@"Bitcoin" image:[UIImage imageNamed:@"bitcoin_payment"] description:@"Estas usando dinero invertido"];

    [self.paymentConfig addPaymentMethodPluginWithPlugin:bitcoinPaymentMethodPlugin];
}

-(void)addCharges {
    NSMutableArray* chargesArray = [[NSMutableArray alloc] init];
    PXPaymentTypeChargeRule* chargeCredit = [[PXPaymentTypeChargeRule alloc] initWithPaymentMethdodId:@"payment_method_plugin" amountCharge:10.5];
    PXPaymentTypeChargeRule* chargeDebit = [[PXPaymentTypeChargeRule alloc] initWithPaymentMethdodId:@"debit_card" amountCharge:8];
    [chargesArray addObject:chargeCredit];
    [chargesArray addObject:chargeDebit];
    // [self.paymentConfig addChargeRulesWithCharges:chargesArray];
}

-(void)setCheckoutPref_CreditCardNotExcluded {
    PXItem *item = [[PXItem alloc] initWithTitle:@"title" quantity:1 unitPrice:3500.0];

    NSArray *items = [NSArray arrayWithObjects:item, nil];

    self.pref = [[PXCheckoutPreference alloc] initWithSiteId:@"MLA" payerEmail:@"sara@gmail.com" items:items];
//    [self.pref addExcludedPaymentType:@"ticket"];
}

-(void)setCheckoutPrefAdditionalInfo {
    // Example SP support for custom additional info.
    self.pref.additionalInfo = @"{\"px_summary\":{\"title\":\"Recarga Claro\",\"image_url\":\"https://www.rondachile.cl/wordpress/wp-content/uploads/2018/03/Logo-Claro-1.jpg\",\"subtitle\":\"Celular 1159199234\",\"purpose\":\"Tu recarga\"}}";
}

-(void)setCheckoutPref_WithId {
    self.pref = [[PXCheckoutPreference alloc] initWithPreferenceId: @"242624092-2a26fccd-14dd-4456-9161-5f2c44532f1d"];
}


-(IBAction)startCardManager:(id)sender  {}

- (void)didFinishWithCheckout:(MercadoPagoCheckout * _Nonnull)checkout {
    [checkout startWithNavigationController:self.navigationController lifeCycleProtocol:self];
}

-(void)failureWithCheckout:(MercadoPagoCheckout * _Nonnull)checkout {
    NSLog(@"PXLog - LazyInit - failureWithCheckout");
}

-(void (^ _Nullable)(void))cancelCheckout {
    return ^ {
        [self.navigationController popViewControllerAnimated:YES];
    };
}

- (void (^)(id<PXResult> _Nullable))finishCheckout {
    return nil;
}

-(void (^)(void))changePaymentMethodTapped {
    return nil;
}

- (void)trackEventWithScreenName:(NSString * _Nullable)screenName action:(NSString * _Null_unspecified)action result:(NSString * _Nullable)result extraParams:(NSDictionary<NSString *,id> * _Nullable)extraParams {
    // Track event
}

- (void)trackScreenWithScreenName:(NSString * _Nonnull)screenName extraParams:(NSDictionary<NSString *,id> * _Nullable)extraParams {
    // Track screen
}

@end
