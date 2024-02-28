//
//  PageViewController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class PageViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
   
    fileprivate var pageViewController: UIPageViewController!
    fileprivate lazy var pageControl = UIPageControl()
    fileprivate lazy var pages: [UIViewController] = {
        return [EditFuelController(), FuelHistoryController()]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 133/255, green: 166/255, blue: 222/255, alpha: 1)
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = appGreenTheme
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        initPageViewController()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissView), name: NSNotification.Name.init("close"), object: nil)
    }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
      if let _ = gestureRecognizer as? UITapGestureRecognizer {
        let touchPoint = touch .location(in: self.view)
          if (touchPoint.y > 40 ){
              return false
          }else{
              return true
          }
      }
      return true
  }
    
    func initPageViewController() {
        let pageHeight = (view.frame.size.height * 0.6)
        let Ycordinate = (view.frame.size.height - pageHeight) / 2
        let pageWidth = (view.frame.size.width * 0.9)
        let Xcordinate = (view.frame.size.width - pageWidth) / 2
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.frame = CGRect(x: Xcordinate, y: Ycordinate, width: pageWidth, height: pageHeight)
        pageViewController.view.layer.cornerRadius = 15.0
        if let firstVC = pages.first {
            DispatchQueue.main.async(execute: {
                self.pageViewController.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
            })
            
        }
        pageViewController.delegate = self
        pageViewController.dataSource = nil
        pageViewController.dataSource = self
        
        view.addSubview(pageViewController.view)
    }
    
    @objc func dismissView() {
        dismiss(animated: false, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: false, completion: nil)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
       return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = pages.first,
            let firstViewControllerIndex = pages.index(of: firstViewController) else {
                return 0
        }
        return firstViewControllerIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return pages.last }
        guard pages.count > previousIndex else { return nil }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return pages.first }
        guard pages.count > nextIndex else { return nil }
        return pages[nextIndex]
    }
    


}
