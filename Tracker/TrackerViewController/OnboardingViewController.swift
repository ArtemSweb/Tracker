//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Артем Солодовников on 10.05.2025.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    var onFinished: (() -> Void)?
    
    //Функция создания Онбординг экрана
    private func createPageViewController(image: UIImage, text: String) -> UIViewController {
        let onboardingScreen = UIViewController()
        let onboardingImage = UIImageView(image: image)
        onboardingImage.contentMode = .scaleAspectFill
        
        let onboardingLabel = UILabel()
        onboardingLabel.text = text
        onboardingLabel.font = .systemFont(ofSize: 32, weight: .bold)
        onboardingLabel.textColor = .tBlack
        onboardingLabel.textAlignment = .center
        onboardingLabel.numberOfLines = 0
        
        let onboardingButton = UIButton(type: .system)
        onboardingButton.setTitle(L10n.onboardingButton, for: .normal)
        onboardingButton.backgroundColor = .onboardingBlack
        onboardingButton.setTitleColor(.white, for: .normal)
        onboardingButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        onboardingButton.layer.cornerRadius = 16
        onboardingButton.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
        
        [onboardingImage, onboardingLabel, onboardingButton].forEach {
            onboardingScreen.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        onboardingScreen.view.sendSubviewToBack(onboardingImage)
        
        NSLayoutConstraint.activate([
            onboardingImage.topAnchor.constraint(equalTo: onboardingScreen.view.topAnchor),
            onboardingImage.bottomAnchor.constraint(equalTo: onboardingScreen.view.bottomAnchor),
            onboardingImage.leadingAnchor.constraint(equalTo: onboardingScreen.view.leadingAnchor),
            onboardingImage.trailingAnchor.constraint(equalTo: onboardingScreen.view.trailingAnchor),
            
            onboardingLabel.leadingAnchor.constraint(equalTo: onboardingScreen.view.leadingAnchor, constant: 16),
            onboardingLabel.trailingAnchor.constraint(equalTo: onboardingScreen.view.trailingAnchor, constant: -16),
            onboardingLabel.bottomAnchor.constraint(equalTo: onboardingButton.topAnchor, constant: -160),
            
            onboardingButton.leadingAnchor.constraint(equalTo: onboardingScreen.view.leadingAnchor, constant: 16),
            onboardingButton.trailingAnchor.constraint(equalTo: onboardingScreen.view.trailingAnchor, constant: -16),
            onboardingButton.bottomAnchor.constraint(equalTo: onboardingScreen.view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            onboardingButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        return onboardingScreen
    }
    
    lazy var pages: [UIViewController] = {
        let blueScreen = createPageViewController(
            image: UIImage(resource: .blueOnboardingBackground),
            text: L10n.onboardingTitleBlue)
        
        let redScreen = createPageViewController(
            image: UIImage(resource: .redOnboardingBackground),
            text: L10n.onboardingTitleRed)
        
        return [blueScreen, redScreen]
    }()
    
    override init(transitionStyle: UIPageViewController.TransitionStyle = .scroll,
                  navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal,
                  options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: transitionStyle,
                   navigationOrientation: navigationOrientation,
                   options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .tBlack
        pageControl.pageIndicatorTintColor = .gray
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}


extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
    
    @objc private func didTapStart() {
        onFinished?()
    }
}


extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return pages.first
        }
        
        return pages[nextIndex]
    }
}
