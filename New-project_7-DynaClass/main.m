//
//  main.m
//  New-project_7-DynaClass
//
//  Created by Geraint on 2018/4/8.
//  Copyright © 2018年 kilolumen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <objc/runtime.h>// 运行时API
#import <objc/message.h>// 运行时系统库中的 消息传递API

//
NSString *greeting(id self, SEL _cmd) {
    return [NSString stringWithFormat:@"Hello World!"];
}

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        // 以动态方式创建一个类
        Class dynaClass = objc_allocateClassPair([NSObject class], "DynaClass", 0);
        
        // 以动态方式添加一个方法，使用已有的方法 （description） 获取特征
        Method description = class_getInstanceMethod([NSObject class],
                                                     @selector(description));
        const char *types = method_getTypeEncoding(description);
        
        /*
        // 运行时系统库中的方法数据类型（objc_method）
        struct objc_method {
            SEL method_name;     // method_name 是一个类型为SEL的变量，它描述了方法的名称；
            char *method_types;  // 变量 method_types 描述了方法参数的数据类型；
            IMP method_imp;      // method_imp 是一个类型为IMP的变量，它在方法被调用时提供方法的地址；
        };
        typedef objc_method Method;
        */
        class_addMethod(dynaClass, @selector(greeting), (IMP)greeting, types);
        
        
        // 注册这个类
        objc_registerClassPair(dynaClass);
        
        // 使用该类创建一个实例并向其发送一条消息
        id dynaObj = [[dynaClass alloc] init];
        
        
        // 注意：在目前版本的Xcode中，需要将 Apple LLVM X.X（版本号） - Preprocessing 中的 Enable Strict Checking of objc_msgSend Calls 设置为No，不然编译会失败。
        NSLog(@"%@",objc_msgSend(dynaObj, NSSelectorFromString(@"greeting")));
        
        
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
