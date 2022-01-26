//
//  ViewController.swift
//  JahezTask
//
//  Created by Satham Hussain on 1/25/22.
//

import UIKit

class CollectionViewRestaurants: UIViewController {
    var restaurantLSt = [Restaurant]()
    enum Section{
        case main
    }
    var dataSource : UICollectionViewDiffableDataSource<Section,Restaurant>!
    var collectionView : UICollectionView!

    override func viewDidLoad() {
        self.title  = "Restaurants"
        self.navigationItem.largeTitleDisplayMode = .always
        super.viewDidLoad()
        createCollectionView()
        dataSourceConfig()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.restaurantLSt.removeAll()
        WebService.fetchRestaurants { restaurant in
            self.restaurantLSt = restaurant
            self.restaurantLSt = self.restaurantLSt.sorted(by: { $0.distance ?? 0.0 > $1.distance ?? 0.0 })
            self.populate(with: self.restaurantLSt)
        }
    }

    private func createLayout() -> UICollectionViewCompositionalLayout{
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }

    private func createCollectionView(){
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createLayout())
        self.view.addSubview(collectionView)
        collectionView.delegate = self
    }

    private func dataSourceConfig(){
        let cell = UICollectionView.CellRegistration<UICollectionViewListCell, Restaurant>{(cell, indexPath, restaurant) in
            var content = cell.defaultContentConfiguration()
            let url = URL(string: restaurant.image ?? "")!
//            self.downloaded(from: url, item: restaurant) { res, img in
//                content.image = img
//            }
            if let data = try? Data(contentsOf: url) {
                content.image = UIImage.init(data: data)
            }
            content.imageProperties.maximumSize = .init(width: 60, height: 60)
            content.imageProperties.cornerRadius = 30
            content.text = restaurant.name  ?? ""
            cell.accessories = [.disclosureIndicator()]
            cell.contentConfiguration = content
        }
        dataSource = UICollectionViewDiffableDataSource<Section, Restaurant>(collectionView: collectionView) {(collectionView: UICollectionView, indexPath: IndexPath, restaurant: Restaurant) in
            return collectionView.dequeueConfiguredReusableCell(using: cell, for: indexPath, item: restaurant)
        }

    }

    func populate(with restaurant : [Restaurant]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.main])
        snapshot.appendItems(restaurant)
        dataSource.apply(snapshot, animatingDifferences: true)
    }



    func downloaded(from url: URL,item: Restaurant, completion: @escaping(_ res : Restaurant, _ img:  UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() {
                completion(item, image)
            }
        }.resume()
    }
    
}

extension CollectionViewRestaurants : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let restaurant = self.restaurantLSt[indexPath.item]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantDetail") as! RestaurantDetail
        vc.restaurant = restaurant
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit)  {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
