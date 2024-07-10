//
//  Disposables.swift
//
//

import ReactiveObjC
import RxSwift

extension RACDisposable: Disposable {}

class RXRACDisposable: RACDisposable {
    private var _bag: DisposeBag?
    public init(_ disposable: Disposable) {
        let bag = DisposeBag()
        disposable.disposed(by: bag)
        self._bag = bag
    }
    
    override func dispose() {
        super.dispose()
        self._bag = nil
    }
}

extension Disposable {
    public func asRACDisposable() -> RACDisposable {
        RXRACDisposable(self)
    }
}
