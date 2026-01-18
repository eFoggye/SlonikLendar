import UIKit

final class WeekdaysNavigationView: UIView {
    private let stack = UIStackView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeWeekdaysNavigationView()
        setUpConstraints()
    }
    
    func makeWeekdaysNavigationView() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.backgroundColor = .white
        stack.translatesAutoresizingMaskIntoConstraints = false
        ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"].forEach { weekday in
            let label = UILabel()
            label.text = weekday
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .black
            label.textAlignment = .center
            stack.addArrangedSubview(label)
        }
        addSubview(stack)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
