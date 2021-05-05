//
//  LaunchScreenManager.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/1/13.
//

import Foundation
import UIKit


class LaunchScreenManager {

    // MARK: - Properties

    // Using a singleton instance and setting animationDurationBase on init makes this class easier to test
    static let instance = LaunchScreenManager(animationDurationBase: 1.3)

    var view: UIView?
    var parentView: UIView?

    let animationDurationBase: Double


    // MARK: - Lifecycle

    init(animationDurationBase: Double) {
        self.animationDurationBase = animationDurationBase
    }


    // MARK: - Animation

    func animateAfterLaunch(_ parentViewPassedIn: UIView) {
        parentView = parentViewPassedIn
        view = loadView()

        fillParentViewWithView()
    }

    func loadView() -> UIView {
        return UINib(nibName: "LaunchScreen", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

    func fillParentViewWithView() {
        parentView!.addSubview(view!)

        view!.frame = parentView!.bounds
        view!.center = parentView!.center
    }
}
