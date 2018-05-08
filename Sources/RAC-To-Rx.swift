//
//  ReactiveObjC-Rx.swift
//
//

import ReactiveObjC
import RxSwift

public extension Observable where E: AnyObject {
    public static func from(_ signal: RACSignal<E>) -> Observable<E?> {
        return Observable<E?>.create { o in
            let subscription = signal.subscribeNext({ v in
                o.onNext(v)
            }, error: { e in
                o.onError(e ?? NSError(domain: "Nil error unwrapped", code: 0, userInfo: nil))
            }, completed: {
                o.onCompleted()
            })
            return subscription
        }
    }
}
