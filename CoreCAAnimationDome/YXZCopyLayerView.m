//
//  YXZCopyLayerView.m
//  CoreCAAnimationDome
//
//  Created by 颜学宙 on 2021/3/2.
//

#import "YXZCopyLayerView.h"

@implementation YXZCopyLayerView
+ (Class)layerClass{
    return [CAReplicatorLayer class];
}

@end
