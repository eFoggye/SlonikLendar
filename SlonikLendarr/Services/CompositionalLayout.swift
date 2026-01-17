import UIKit
enum CompositionalLayout {
    static func makeCompositionalLayout() -> UICollectionViewCompositionalLayout{
        //Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0/7.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 0, bottom: 1, trailing: 0)
        //Group
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
        //Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(60))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        header.pinToVisibleBounds = true
        //Section
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
