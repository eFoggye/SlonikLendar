import UIKit
extension YearViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return months.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return months[section].days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.identifier, for: indexPath) as! DayCell
        let day = months[indexPath.section].days[indexPath.item]
        cell.dayToDisplay(day: day, hasEvents: viewModel.hasEvents(for: day.date))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MonthReusableView.identifier, for: indexPath) as! MonthReusableView
        let russianNameOfMonth = helper.russianNameOfMonth(month: months[indexPath.section])
        header.configureHeader(with: russianNameOfMonth)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = months[indexPath.section].days[indexPath.item]
        guard day.isItInThismonth else {return}
        let vc = DayTimelineViewController(day: day)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
