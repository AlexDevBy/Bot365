//
//  HomeViewController.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 22.11.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let contentView = HomeScreenView()
    private var suggestionsSource: [ICellShowable] = []
    private var categoriesSource: [CategoriesModels] = []
    private let presenter: IHomeScreenPresenter
    private let loaderViewController: LoaderViewController
    private let presentationAssembly: IPresentationAssembly
    private var indexOfCellBeforeDragging = 0
    private var lastSelectedIndexPathForDocumentInCollectionView: IndexPath = IndexPath(row: 0, section: 0)
    
    init(presenter: IHomeScreenPresenter,
         presentationAssembly: IPresentationAssembly) {
        self.presenter = presenter
        self.presentationAssembly = presentationAssembly
        self.loaderViewController = presentationAssembly.getLoaderScreen()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
        presenter.attachView(view: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDelegates()
    }
    
    private func setupView() {
        suggestionsSource = presenter.getSuggestions()
        categoriesSource = presenter.getCategories()
        contentView.pageControl.currentPage = 0
        contentView.pageControl.numberOfPages = suggestionsSource.count
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupDelegates() {
        contentView.suggestionCollectionView.register(SuggestionCollectionViewCell.self, forCellWithReuseIdentifier: SuggestionCollectionViewCell.reuseID)
        contentView.suggestionCollectionView.dataSource = self
        contentView.suggestionCollectionView.delegate = self
        
        contentView.categoriesCollectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: CategoriesCollectionViewCell.reuseID)
        contentView.categoriesCollectionView.dataSource = self
        contentView.categoriesCollectionView.delegate = self
    }

}

//MARK: UICollectionView methods
extension HomeViewController: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard scrollView == contentView.suggestionCollectionView else {return}
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == contentView.suggestionCollectionView else {return}
        targetContentOffset.pointee = scrollView.contentOffset
        let indexOfMajorCell = self.indexOfMajorCell()
        
        // calculate conditions:
        let swipeVelocityThreshold: CGFloat = 0.7 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < suggestionsSource.count && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            lastSelectedIndexPathForDocumentInCollectionView = IndexPath(row: snapToIndex, section: 0)
            let toValue = contentView.flowLayout.itemSize.width * CGFloat(snapToIndex)
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: {_ in
                self.selectItemLogic()
            })
        } else {
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            lastSelectedIndexPathForDocumentInCollectionView = indexPath
            contentView.suggestionCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard scrollView == contentView.suggestionCollectionView else {return}
        if scrollView.isDescendant(of: contentView.suggestionCollectionView) {
            contentView.pageControl.currentPage = indexOfMajorCell()
            selectItemLogic()
        }
    }
    
    private func selectItemLogic() {
        contentView.suggestionCollectionView.isScrollEnabled = true
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = contentView.flowLayout.itemSize.width
        let proportionalOffset = contentView.suggestionCollectionView.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(suggestionsSource.count - 1, index))
        return safeIndex
    }
}

// MARK: - View
extension HomeViewController: IHomeView {
    func reloadSugesstions(types: [ICellShowable]) {
        self.suggestionsSource = types
        contentView.suggestionCollectionView.reloadData()
    }
    
    func showMessage(text: String) {
        displayMsg(title: nil, msg: text)
    }
    
    func showLoader() {
        tabBarController?.present(loaderViewController, animated: false)
    }
    
    func hideLoader() {
        loaderViewController.hideLoader()
    }
}

// MARK: UICollectionView methods
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case contentView.categoriesCollectionView:
            guard let sportType = categoriesSource[safe: indexPath.row]?.type else { return }
            let vc = presentationAssembly.sportObjectList(sportType: sportType)
            navigationController?.pushViewController(vc, animated: true)
        case contentView.suggestionCollectionView:
            guard let type = (suggestionsSource[safe: indexPath.row] as? SuggestionsModels)?.type else { return }
            guard
                type == .adds
            else {
                let vc = presentationAssembly.sportObjectList(sportType: type)
                navigationController?.pushViewController(vc, animated: true)
                return
            }
            presenter.buyRemoveAdd()
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case contentView.suggestionCollectionView:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        case contentView.categoriesCollectionView:
            return CGSize(width: collectionView.frame.width/2 - HomeScreenView.Constants.interItemSpacing, height: 100)
        default:
            return CGSize.zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case contentView.suggestionCollectionView:
            return suggestionsSource.count
        case contentView.categoriesCollectionView:
            return categoriesSource.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case contentView.suggestionCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionCollectionViewCell.reuseID, for: indexPath) as! SuggestionCollectionViewCell
            cell.suggestionsModel = suggestionsSource[safe: indexPath.row]
            return cell
        case contentView.categoriesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.reuseID, for: indexPath) as! CategoriesCollectionViewCell
            cell.categoriesModel = categoriesSource[safe: indexPath.row]
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollView {
        case contentView.suggestionCollectionView:
            contentView.pageControl.currentPage = indexOfMajorCell()
        default:
            return
        }
    }
}
