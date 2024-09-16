//
//  ViewController.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 16.09.24.
//

import UIKit

class SplashViewController: UIViewController {
    private var splashPageViewController: SplashPageViewController!

    @IBOutlet weak var firstDot: UIButton!
    @IBOutlet weak var secondDot: UIButton!
    @IBOutlet weak var nextButton: BaseButton!
    @IBOutlet weak var skipButton: BaseButton!
    @IBOutlet weak var firstDotWidthConst: NSLayoutConstraint!
    @IBOutlet weak var secondDotWidthConst: NSLayoutConstraint!
    @IBOutlet weak var termsOfUse: UIButton!
    @IBOutlet weak var privacyPolicy: UIButton!
    
    private var currentIndex = -1
    private var pages: [FirstSplashViewController] = [FirstSplashViewController(nibName: "FirstSplashViewController", bundle: nil), FirstSplashViewController(nibName: "FirstSplashViewController", bundle: nil)]

    override func viewDidLoad() {
        super.viewDidLoad()
        pages.last?.index = 1
        setCurrentPage(index: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desinationViewController = segue.destination as? SplashPageViewController {
            splashPageViewController = desinationViewController
            splashPageViewController.delegate = self
            splashPageViewController.dataSource = self
        }
    }
    
    func pageChangedTo(index: Int) {
        switch index {
        case 0:
            firstDot.backgroundColor = .white
            secondDot.backgroundColor = .black.withAlphaComponent(0.5)
        case 1:
            secondDot.backgroundColor = .white
            firstDot.backgroundColor = .black.withAlphaComponent(0.5)
        default:
            break
        }
    }
    
    func setCurrentPage(index: Int) {
        if index == currentIndex { return }
        let direction: UIPageViewController.NavigationDirection = index < currentIndex ? .reverse : .forward
        currentIndex = index
        splashPageViewController.setViewControllers([pages[index]], direction: direction, animated: true, completion: nil)
        pageChangedTo(index: index)
    }
    
    func goToMenu() {
        UserDefaults.standard.set(true, forKey: .hasLaunchedBeforeKey)
        let menuVC = MenuViewController(nibName: "MenuViewController", bundle: nil)
        let navigationController = NavigationViewController(rootViewController: menuVC)
        navigationController.setAsRoot()
    }
    
    @IBAction func chooseFirstPage(_ sender: UIButton) {
        setCurrentPage(index: 0)
    }

    @IBAction func chooseSecondPage(_ sender: UIButton) {
        setCurrentPage(index: 1)
    }

    @IBAction func clickedSkip(_ sender: UIButton) {
        goToMenu()
    }
    
    @IBAction func clickedNext(_ sender: UIButton) {
        if currentIndex == 0 {
            setCurrentPage(index: 1)
        } else {
            goToMenu()
        }
    }
    
}

extension SplashViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentPage = pageViewController.viewControllers?.first {
            let index = pages.firstIndex(of: currentPage as! FirstSplashViewController)!
            currentIndex = index
            pageChangedTo(index: index)
        }
    }
}

extension SplashViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.pages.firstIndex(of: viewController as! FirstSplashViewController)!
        if (index == 0) {
            return nil
        } else {
            return self.pages[index - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.pages.firstIndex(of: viewController as! FirstSplashViewController)!
        if (index == self.pages.count - 1) {
            return nil
        } else {
            return self.pages[index + 1]
        }
    }
}

extension UIViewController {
    func setAsRoot() {
        UIApplication.shared.windows.first?.rootViewController = self
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
