//
//  AlixPayClient.h
//  AliPay
//
//  Created by WenBi on 11-5-16.
//  Copyright 2011 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AlixPayResult.h"

#define IS_IPAD ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define PARTNER @"2088701585224741"
#define SELLER  @"2088701585224741"
#define RSA_PRIVATE @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAJhkRhjcpiPmfjjzA5fCY1QEkMklD0N/VL47UTwgaIkrRNPYFLqeXDnc7v4yVRBMYnWv7s41fMZLtthdtEZfrECUT8p8jKwBnYZ8aRVGB26OJITBIXorbNjgiqBLoj5P5I7QoaNxpHLEZQz6KVJSv4u8rYcRQl0IwolROJ/9MsdxAgMBAAECgYA5u2NC7/SRDTUsZgQqbh4rKj+ftEaAD7EPEHHKEY0Iyjec+fOAb5YI5cY0zuSi9A0pAKm7vU+z3+M5POaa8ovSpbCWhH/4WYMnH28KPAbvtyXYd3UxJayUrrt/4QI9M4O+EZPppmKBDZqPZLDN8BaOMpSZcGyPPNQFCfzFxctnAQJBAMiypmGU/Cgycjl4yiXT7UzqMyI2j1gp42i7l+Fm5OXNgZFIrTpdHVqbCrp4ISseJGtvb5wpwgDx9vmFZVWDG/kCQQDCYhPtM9pQqLtlUEquhXV6lO9yeyP1pBrXiJpUhAoLGI+6pVpqIW+5w8VMWhluMYbl+t017mqttGyVdu7nrzU5AkEAtFn+NCCa/FBg3w6Rsa6hR4YKT0tyQwrZZct2L8K0HWIwdes2aAU3FK3Q1UKQo9uhZL4uMMpBoXHOu+nI5zA7mQJAOkp5GUfUbx26XI5wZteEvEbPa3A7/1y/4+SGC1QxQtSRvXH6pBr0yytHDjdyqtXVU0AgeBzQBtk1OrkYuYeUGQJBAJQqDnevLSM2hef48gsVzCosJK8SGWjnMqT1t5D4Uek7iHKHxHoBhizWZMNLDSfs7R+hW2fZcZyKbbfK8sHOT1M="

#define RSA_ALIPAY_PUBLIC  @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCQXLniY1EcpHbo0T00EQwAmT9B13k9mYoKPboH 4UBniw1uXjfCc3Upa+UZPghYMiSh32LksUqMdAgRyX11uvK7iqQX/yYHyMgnh1E2F3qXmDMwPMXi Ic64nmYCZqjXlYjUYPa4rLUImWc7KylK/BMHLz6kaLo7bG7unIftls+LVwIDAQAB"
enum {
	kSPErrorOK,
	kSPErrorAlipayClientNotInstalled,
	kSPErrorSignError,
};


@interface AlixPay : NSObject {
}

+ (AlixPay *)shared;

- (int)pay:(NSString *)orderString applicationScheme:(NSString *)scheme;
- (AlixPayResult *)handleOpenURL:(NSURL *)url;

@end
