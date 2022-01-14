//
//  CollectionViewController.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/11.
//

import UIKit

private enum Section: Hashable {
  case main
}

class CollectionViewController: UIViewController {
  
  @IBOutlet private weak var segmentControl: UISegmentedControl!
  @IBOutlet private var collectionView: UICollectionView!
  
  private var dataSource: UICollectionViewDiffableDataSource<Section, Product>! = nil
  private let api = APIManager(urlSession: URLSession(configuration: .default))
  private var product: [Product] = []
  
  private lazy var activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.center = self.view.center
    activityIndicator.style = .medium
    activityIndicator.hidesWhenStopped = true
    activityIndicator.startAnimating()
    return activityIndicator
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(activityIndicator)
    registerNibForCell()
    fetchData()
    refreshAnimate()
  }
  
  @IBAction private func segmentControlDidTap(_ sender: UISegmentedControl) {
    changeCollectionViewLayout(by: sender.selectedSegmentIndex)
  }
  
  private func changeCollectionViewLayout(by selectedSegmentIndex: Int) {
    switch selectedSegmentIndex {
    case 0:
      //collectionView.collectionViewLayout = createListViewLayout()
      //self.collectionView.delegate = self
      configureListViewDataSource()
    case 1:
      //collectionView.collectionViewLayout = createGridViewLayout()
      configureGridViewDataSource()
    default:
      return
    }
  }
  
  private func refreshAnimate() {
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = UIColor.darkGray
    refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    self.collectionView.refreshControl = refreshControl
  }
  
  @objc private func handleRefresh(sender: AnyObject) {
    fetchData()
    changeCollectionViewLayout(by: segmentControl.selectedSegmentIndex)
    collectionView.reloadData()
    self.collectionView.refreshControl?.endRefreshing()
  }
  
  private func fetchData() {
    api.productList(pageNumber: 1, itemsPerPage: 10) { response in
      switch response {
      case .success(let data):
        self.product = data.pages
        DispatchQueue.main.async {
          self.collectionView.delegate = self
          self.configureListViewDataSource()
          self.activityIndicator.removeFromSuperview()
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
  private func registerNibForCell() {
    let productCollectionViewListCellNib = UINib(nibName: ProductCollectionViewListCell.nibName, bundle: nil)
    self.collectionView.register(productCollectionViewListCellNib, forCellWithReuseIdentifier: ProductCollectionViewListCell.reuseIdentifier)
    
    let productCollectionViewGridCellNib = UINib(nibName: ProductCollectionViewGridCell.nibName, bundle: nil)
    self.collectionView.register(productCollectionViewGridCellNib, forCellWithReuseIdentifier: ProductCollectionViewGridCell.reuseIdentifier)
  }
}

//extension CollectionViewController {
//  private func createListViewLayout() -> UICollectionViewLayout {
//    let layout = UICollectionViewCompositionalLayout{
//      // 만들게 되면 튜플 (키: 값, 키: 값) 의 묶음으로 들어옴 반환 하는 것은 NSCollectionLayoutSection 콜렉션 레이아웃 섹션을 반환해야함
//      (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
//
//      // 아이템에 대한 사이즈 - absolute 는 고정값, estimated 는 추측, fraction 퍼센트
//      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//
//      // 위에서 만든 아이템 사이즈로 아이템 만들기
//      let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//      // 아이템 간의 간격 설정
//      //item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
//
//      // 변경할 부분
//      let groupHeight = NSCollectionLayoutDimension.fractionalHeight(0.083)
//
//      // 그룹사이즈
//      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
//
//      // 변경할 부분
//      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
//
//      // 그룹으로 섹션 만들기
//      let section = NSCollectionLayoutSection(group: group)
//      //            section.orthogonalScrollingBehavior = .groupPaging
//
//      // 섹션에 대한 간격 설정
////      section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
//      return section
//    }
//    return layout
//  }
//  }
//
//  private func createGridViewLayout() -> UICollectionViewLayout {
//    let layout = UICollectionViewCompositionalLayout{
//      // 만들게 되면 튜플 (키: 값, 키: 값) 의 묶음으로 들어옴 반환 하는 것은 NSCollectionLayoutSection 콜렉션 레이아웃 섹션을 반환해야함
//      (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
//
//      // 아이템에 대한 사이즈 - absolute 는 고정값, estimated 는 추측, fraction 퍼센트
//      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//
//      // 위에서 만든 아이템 사이즈로 아이템 만들기
//      let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//      // 아이템 간의 간격 설정
//      item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
//
//      // 변경할 부분
//      let groupHeight = NSCollectionLayoutDimension.fractionalWidth(0.677)
//
//      // 그룹사이즈
//      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
//
//      // 변경할 부분
//      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
//
//      // 그룹으로 섹션 만들기
//      let section = NSCollectionLayoutSection(group: group)
//      //            section.orthogonalScrollingBehavior = .groupPaging
//
//      // 섹션에 대한 간격 설정
//      section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
//      return section
//    }
//    return layout
//  }


extension CollectionViewController {
  private func configureListViewDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) {
      (collectionView: UICollectionView, indexPath: IndexPath, item: Product) -> UICollectionViewListCell? in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewListCell.reuseIdentifier, for: indexPath) as? ProductCollectionViewListCell else {
        return UICollectionViewListCell()
      }
      guard let imageURL = URL(string: item.thumbnail) else {
        return UICollectionViewListCell()
      }
      guard let imageData = try? Data(contentsOf: imageURL), let image = UIImage(data: imageData) else {
        return UICollectionViewListCell()
      }

      cell.configureCell(image: image, name: item.name, price: item.getPriceForList, fixedPrice: item.fixedPrice, stock: item.getStock)

      return cell
    }
    
    // initial data
    var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
    snapshot.appendSections([.main])
    snapshot.appendItems(product)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  private func configureGridViewDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) {
      (collectionView: UICollectionView, indexPath: IndexPath, item: Product) -> UICollectionViewCell? in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewGridCell.reuseIdentifier, for: indexPath) as? ProductCollectionViewGridCell else {
        return UICollectionViewCell()
      }

      guard let imageURL = URL(string: item.thumbnail), let imageData = try? Data(contentsOf: imageURL), let image = UIImage(data: imageData) else {
        return UICollectionViewCell()
      }
      
      cell.configureCell(image: image, name: item.name, price: item.getPriceForGrid, fixedPrice: item.fixedPrice, stock: item.getStock)
      
      return cell
    }
    
    // initial data
    var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
    snapshot.appendSections([.main])
    snapshot.appendItems(product)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}

extension CollectionViewController: UICollectionViewDelegate {
  
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.size.width
    if segmentControl.selectedSegmentIndex == 0 {
      return CGSize(width: width, height: width / 7)
    } else {
      return CGSize(width: width / 2.2, height: width / 1.5)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                     layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    if segmentControl.selectedSegmentIndex == 0 {
      return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    } else {
      return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
  }
  

  func collectionView(_ collectionView: UICollectionView,
                     layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    if segmentControl.selectedSegmentIndex == 0 {
      return 5
    } else {
      return 8
    }
  }

  func collectionView(_ collectionView: UICollectionView,
                     layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 5
  }
}
