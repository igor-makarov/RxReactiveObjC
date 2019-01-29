//
//  ReactiveObjC-Rx.swift
//
//

import ReactiveObjC
import RxSwift

public extension Observable where E: AnyObject {
    static func from(signal: RACSignal<E>?) -> Observable<E?> {
        guard let signal = signal else { return .empty() }
        
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

public extension ObservableType {
    func rxrac_nonNilValues<T>() -> Observable<T> where E == T? {
        // swiftlint:disable:next force_unwrapping
        return self.filter { $0 != nil }.map { $0! }
    }
}
