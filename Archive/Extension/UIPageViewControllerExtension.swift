//
//  UIPageViewControllerExtension.swift
//  Archive
//
//  Created by hanwe on 2021/10/27.
//

import UIKit

extension UIPageViewController {

    func moveToNextPage() {
       guard let currentViewController = self.viewControllers?.first else { return }
       guard let nextViewController = dataSource?.pageViewController( self, viewControllerAfter: currentViewController ) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }

    func moveToPreviousPage() {
       guard let currentViewController = self.viewControllers?.first else { return }
       guard let previousViewController = dataSource?.pageViewController( self, viewControllerBefore: currentViewController ) else { return }
       setViewControllers([previousViewController], direction: .reverse, animated: true, completion: nil)
    }

}
