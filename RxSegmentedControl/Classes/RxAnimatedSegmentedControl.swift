//
//  RxAnimatedSegmentedControl.swift
//  RxSegmentedControl
//
//  Created by 王小涛 on 2019/3/6.
//

import RxSwift
import RxCocoa

public class RxAnimatedSegmentedControl: RxSegmentedControl {

    public var animatedView = UIView() {
        didSet {
            oldValue.removeFromSuperview()
            addSubview(animatedView)
            animatedView.isHidden = false
        }
    }

    override func setup() {
        super.setup()

        currentIndex
            .delay(0.1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.scrollAnimatedView(to: $0)
            })
            .disposed(by: disposeBag)
    }

    func scrollAnimatedView(to index: Int) {

        guard index >= 0 && index < stackView.arrangedSubviews.count else {
            return
        }

        bringSubviewToFront(animatedView)

        let arrangedSubview = stackView.arrangedSubviews[index]
        let arrangedSubviewFrame = stackView.convert(arrangedSubview.frame, to: self)

        let size = animatedView.frame.size

        let origin: CGPoint = {
            let x = arrangedSubviewFrame.minX + (arrangedSubviewFrame.width - size.width) / 2
            let y = stackView.bounds.height - animatedView.bounds.height
            return CGPoint(x: x, y: y)
        }()

        UIView.animate(withDuration: 0.2, animations: {
            self.animatedView.frame = CGRect(origin: origin, size: size)
        }) { _ in
            self.animatedView.isHidden = false
        }
    }
}
