//
//  ViewController.swift
//  RxSegmentedControl
//
//  Created by wangxiaotao on 03/06/2019.
//  Copyright (c) 2019 wangxiaotao. All rights reserved.
//

import UIKit
import RxSegmentedControl
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var segmentedControl: RxAnimatedSegmentedControl!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        segmentedControl.items = ["1", "2", "3"]

        segmentedControl.items = ["3", "2", "3"]

        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 2)))
        view.backgroundColor = .red
        segmentedControl.animatedView = view
        segmentedControl.titleTextAttributesForNarmalState = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        segmentedControl.titleTextAttributesForSelectedState = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)]
//        segmentedControl.itemWidth = 50

        segmentedControl.currentIndex.subscribe(onNext: {
            print("currentIndex = \($0)")
        }).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

