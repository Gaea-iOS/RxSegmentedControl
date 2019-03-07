//
//  RxSegmentedControl.swift
//  RxSegmentedControl
//
//  Created by 王小涛 on 2019/3/6.
//

import RxSwift
import RxCocoa
import RxSwiftExt

public protocol SegmentControlItem {
    var itemTitle: String { get }
}

extension String: SegmentControlItem {
    public var itemTitle: String {
        return self
    }
}

public class RxSegmentedControl: UIView {

    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [])
        view.axis = .horizontal
        view.distribution = .fillEqually
        self.addSubview(view)
        return view
    }()

    public var items: [SegmentControlItem] = [] {
        didSet {
            setup()
        }
    }

    public var itemWidth: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    public var titleTextAttributesForNarmalState: [NSAttributedString.Key : Any]? = nil {
        didSet {
            stackView
                .arrangedSubviews
                .map { $0 as! SegmentedControlItem }
                .forEach { [unowned self] in
                    $0.titleTextAttributesForNarmalState = self.titleTextAttributesForNarmalState
            }
        }
    }

    public var titleTextAttributesForSelectedState: [NSAttributedString.Key : Any]? = nil {
        didSet {
            stackView
                .arrangedSubviews
                .map { $0 as! SegmentedControlItem }
                .forEach { [unowned self] in
                    $0.titleTextAttributesForSelectedState = self.titleTextAttributesForSelectedState
            }
        }
    }

    public let currentIndex = BehaviorRelay<Int>(value: 0)

    public func item(at index: Int) -> UIView {
        return stackView.arrangedSubviews[index]
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds

        if itemWidth > 0 {
            stackView.spacing = (stackView.bounds.width - CGFloat(stackView.arrangedSubviews.count) * itemWidth) / CGFloat(stackView.arrangedSubviews.count - 1)
        }
    }

    var disposeBag = DisposeBag()

    func setup() {

        disposeBag = DisposeBag()

        stackView.removeAllArrangedSubviews()

        let buttons: [SegmentedControlItem] = items.enumerated().map { [unowned self] in

            let button = SegmentedControlItem()
            button.title = $0.element.itemTitle
            button.titleTextAttributesForNarmalState = self.titleTextAttributesForNarmalState
            button.titleTextAttributesForSelectedState = self.titleTextAttributesForSelectedState

            button.rx.tap
                .mapTo($0.offset)
                .bind(to: currentIndex)
                .disposed(by: disposeBag)

            currentIndex
                .map { [offset = $0.offset] in $0 == offset }
                .bind(to: button.rx.isSelected)
                .disposed(by: disposeBag)

            button.backgroundColor = .yellow
            return button
        }

        buttons.forEach { [unowned self] in self.stackView.addArrangedSubview($0) }

        setNeedsLayout()
        layoutIfNeeded()
    }
}

class SegmentedControlItem: UIButton {

    var titleTextAttributesForNarmalState: [NSAttributedString.Key : Any]? {
        didSet {
            setupTitle()
        }
    }

    var titleTextAttributesForSelectedState: [NSAttributedString.Key : Any]? {
        didSet {
            setupTitle()
        }
    }

    var title: String? {
        didSet {
            setupTitle()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.textAlignment = .center
        setupTitle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTitle() {
        let normalString = NSAttributedString(string: title ?? "", attributes: titleTextAttributesForNarmalState)
        setAttributedTitle(normalString, for: .normal)
        let selectedString = NSAttributedString(string: title ?? "", attributes: titleTextAttributesForSelectedState)
        setAttributedTitle(selectedString, for: .selected)
    }
}

extension UIStackView {

    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { [unowned self] in self.removeArrangedSubview($0) }
    }
}
