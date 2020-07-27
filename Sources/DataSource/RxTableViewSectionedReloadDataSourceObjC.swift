//

#if os(iOS)

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactiveObjC

public typealias CellForRowBlock = (UITableView, IndexPath, NSObject) -> UITableViewCell
public typealias CanEditRowBlock = (IndexPath) -> Bool

@objc(SectionedValue)
public class SectionedValueObjC: NSObject {
    @objc public let section: NSObject
    @objc public let values: [NSObject]
    
    @objc(initWithSection:values:)
    public init(section: NSObject, values: [NSObject]) {
        self.section = section
        self.values = values
    }
    
    @objc(packSection:values:)
    public static func pack(section: NSObject, values: [NSObject]) -> SectionedValueObjC {
        return SectionedValueObjC(section: section, values: values)
    }
}

extension NSObject: IdentifiableType {
    public var identity: NSObject {
        return self
    }
    
    public typealias Identity = NSObject
}

typealias SectionModelImpl = AnimatableSectionModel<NSObject, NSObject>

func convertSectionedValues(_ objcSectionedValues: [SectionedValueObjC]) -> [SectionModelImpl] {
    return objcSectionedValues.map {
        return SectionModelImpl(model: $0.section, items: $0.values)
    }
}

func convertFromSectionedValues(_ sectionedValues: [SectionModelImpl]) -> [SectionedValueObjC] {
    return sectionedValues.map {
        return SectionedValueObjC(section: $0.model, values: $0.items)
    }
}

@objc(RxTableViewSectionedDataSource)
public final class RxTableViewSectionedReloadDataSourceObjC: NSObject {
    var disposeBag = DisposeBag()
    
    @objc
    public final var tableView: UITableView? {
        didSet {
            rebindDataSource()
        }
    }

    @objc
    public final var cellForRow: CellForRowBlock? {
        didSet {
            rebindDataSource()
        }
    }

    @objc
    public final var canEditRow: CanEditRowBlock? {
        didSet {
            rebindDataSource()
        }
    }

    @objc
    public var insertionAnimation = UITableView.RowAnimation.none {
        didSet {
            rebindDataSource()
        }
    }
    @objc
    public var deletionAnimation = UITableView.RowAnimation.none {
        didSet {
            rebindDataSource()
        }
    }
    @objc
    public var reloadAnimation = UITableView.RowAnimation.none {
        didSet {
            rebindDataSource()
        }
    }
    
    @objc
    public final var sectionsSignal: RACSignal<AnyObject>? {
        didSet {
            rebindDataSource()
        }
    }
    
    weak var dataSource: TableViewSectionedDataSource<SectionModelImpl>?
    
    @objc
    public var sectionedValues: [SectionedValueObjC]? {
        guard let dataSource = dataSource else { return nil }
        return convertFromSectionedValues(dataSource.sectionModels)
    }
    
    func rebindDataSource() {
        disposeBag = DisposeBag()
        guard let tableView = tableView else { return }
        guard let cellforRow = cellForRow else { return }
        let canEditRowBlock: ((TableViewSectionedDataSource<SectionModelImpl>, IndexPath) -> Bool)
        if let canEditRow = canEditRow {
            canEditRowBlock = { canEditRow($1) }
        } else {
            canEditRowBlock = { _, _ in false }
        }

        let sectionSignalObservable = sectionsSignal.map {
            return Observable.from(signal: $0)
                .rxrac_nonNilValues()
                .map { $0 as? [SectionedValueObjC] }
                .rxrac_nonNilValues()
                .map { convertSectionedValues($0) }
        }
        
        let observableSignal = sectionSignalObservable ?? Observable.just([])
        
        if insertionAnimation == .none && deletionAnimation == .none && reloadAnimation == .none {
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModelImpl>(configureCell: { cellforRow($1, $2, $3) })
            self.dataSource = dataSource
            dataSource.canEditRowAtIndexPath = canEditRowBlock
            
            observableSignal
                .bind(to: tableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        } else {
            let dataSource = RxTableViewSectionedAnimatedDataSource<SectionModelImpl>(configureCell: { cellforRow($1, $2, $3) })
            self.dataSource = dataSource
            dataSource.animationConfiguration =
                AnimationConfiguration(insertAnimation: insertionAnimation,
                                       reloadAnimation: reloadAnimation,
                                       deleteAnimation: deletionAnimation)

            dataSource.canEditRowAtIndexPath = canEditRowBlock

            observableSignal
                .bind(to: tableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        }
        
    }

    @objc(sectionAtIndex:)
    public func section(at index: Int) -> NSObject? {
        guard let sectionedValues = sectionedValues else { return nil }
        guard sectionedValues.count > index else { return nil }
        return sectionedValues[index].section
    }

    @objc(valueAtIndexPath:)
    public func value(at indexPath: IndexPath) -> NSObject? {
        guard indexPath.indices.count > 1 else { return nil }
        guard let sectionedValues = sectionedValues else { return nil }
        guard sectionedValues.count > indexPath.section else { return nil }
        guard sectionedValues[indexPath.section].values.count > indexPath.row else { return nil }
        return sectionedValues[indexPath.section].values[indexPath.row]
    }
}

#endif
