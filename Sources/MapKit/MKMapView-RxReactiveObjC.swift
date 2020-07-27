//

#if os(iOS) && canImport(RxMKMapView)

import MapKit
import RxMKMapView
import ReactiveObjC
import RxSwift

public extension MKMapView {
    @objc(bindAnnotationsToSignal:)
    func bindAnnotations(to signal: RACSignal<NSArray>) -> RACDisposable {
        let observable = Observable.from(signal: signal).rxrac_nonNilValues().map { $0 as! [MKAnnotation] }
        return RXRACDisposable(rx.annotations(observable))
    }

    @objc(bindOverlaysToSignal:)
    func bindOverlays(to signal: RACSignal<NSArray>) -> RACDisposable {
        let observable = Observable.from(signal: signal).rxrac_nonNilValues().map { $0 as! [MKOverlay] }
        return RXRACDisposable(rx.overlays(observable))
    }
}

#endif
