import UIKit

final class MonthReusableView: UICollectionReusableView {
    
    static let identifier = "MonthReusableView"
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .black
        return label
    }()
    
    let layerUnderHeader: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(monthLabel)
        addSubview(layerUnderHeader)
        backgroundColor = .white
        setUpConstraints()
    }
    
    func configureHeader (with text: String) {
        monthLabel.text = text
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            monthLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            layerUnderHeader.topAnchor.constraint(equalTo: monthLabel.bottomAnchor),
            layerUnderHeader.heightAnchor.constraint(equalToConstant: 3),
            layerUnderHeader.leadingAnchor.constraint(equalTo: leadingAnchor),
            layerUnderHeader.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
