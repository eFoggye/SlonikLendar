import UIKit

final class EventView: UIView {
    let nameLabel = UILabel()
    let event: Event
    var onTap: ((Event) -> Void)?
    init(event: Event) {
        self.event = event
        super.init(frame: .zero)
        createEvent()
        setUpConstraints()
    }
    func createEvent() {
        backgroundColor = .systemCyan
        alpha = 0.5
        layer.cornerRadius = 15

        nameLabel.text = event.name
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .boldSystemFont(ofSize: 25)
        accessibilityIdentifier = event.name
        addSubview(nameLabel)
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25)
        ])
    }
    @objc func handleTap() {
        onTap?(event)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
