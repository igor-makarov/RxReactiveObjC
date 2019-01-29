//
//  Rx-To-RAC.swift
//
//

import ReactiveObjC
import RxSwift

public extension Observable where E: AnyObject {
    func asSignal() -> RACSignal<E> {
        return RACSignal<E>.createSignal { s -> RACDisposable? in
            let subscription = self.subscribe(onNext: { v in
                s.sendNext(v)
            }, onError: { e in
                s.sendError(e)
            }, onCompleted: {
                s.sendCompleted()
            })
            return RXRACDisposable(subscription)
        }
    }
}

public extension PrimitiveSequenceType where TraitType == CompletableTrait, ElementType == Never {
    func asSignal() -> RACSignal<AnyObject> {
        return RACSignal<AnyObject>.createSignal { s -> RACDisposable? in
            let subscription = self.subscribe(onCompleted: { s.sendCompleted() }, onError: { e in s.sendError(e) })
            return RXRACDisposable(subscription)
        }
    }
}
