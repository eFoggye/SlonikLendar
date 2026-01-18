import UIKit
enum CompositionalLayout {
    static func makeCompositionalLayout() -> UICollectionViewCompositionalLayout{
        //MARK: - Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0/7.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 0, bottom: 1, trailing: 0)
        //MARK: - Group
        let rowGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100))
        let rowGroup = NSCollectionLayoutGroup.horizontal(layoutSize: rowGroupSize, subitems: [item])
        
        let monthGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(70))
        let monthGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: monthGroupSize,
            repeatingSubitem: rowGroup,
            count: 6)
        //MARK: - Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(60))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        header.pinToVisibleBounds = true
        //MARK: - Section
        let section = NSCollectionLayoutSection(group: monthGroup)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 50,
            leading: 0,
            bottom: 0,
            trailing: 0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
