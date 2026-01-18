import UIKit

final class DayCell: UICollectionViewCell {
    static let identifier = "DayCell"
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var rectView = createRectForToday()
    private lazy var topLayer = createTopLayer()
    private lazy var eventRect = createEventRect()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(rectView)
        contentView.addSubview(dayLabel)
        contentView.addSubview(topLayer)
        contentView.addSubview(eventRect)
        setUpConstraints()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        rectView.isHidden = true
        dayLabel.text = nil
        dayLabel.textColor = .black
        topLayer.isHidden = false
        eventRect.isHidden = true
        contentView.isUserInteractionEnabled = true
    }
    public func dayToDisplay(day: DayModel, hasEvents: Bool) {
        dayLabel.text = String(day.day)
        if day.isCurrentMonth {
            dayLabel.textColor = .black
        } else {
            dayLabel.textColor = .darkGray
        }
        if day.isToday {
            dayLabel.textColor = .white
            rectView.isHidden = false
            
        }
        if !day.isItInThismonth {
            topLayer.isHidden = true
            dayLabel.text = ""
            dayLabel.textColor = .white
            contentView.isUserInteractionEnabled = false
        }
        if hasEvents {
            eventRect.isHidden = false
        }
    }
    func createRectForToday () -> UIView {
        let rectView = UIView()
        rectView.backgroundColor = .red
        rectView.layer.cornerRadius = 22.5
        rectView.clipsToBounds = true
        rectView.translatesAutoresizingMaskIntoConstraints = false
        rectView.isHidden = true
        return rectView
    }
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rectView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            rectView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rectView.widthAnchor.constraint(equalToConstant: 45),
            rectView.heightAnchor.constraint(equalToConstant: 45),
            
            topLayer.topAnchor.constraint(equalTo: contentView.topAnchor),
            topLayer.heightAnchor.constraint(equalToConstant: 1.5),
            topLayer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topLayer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            eventRect.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 10),
            eventRect.heightAnchor.constraint(equalToConstant: 7.5),
            eventRect.widthAnchor.constraint(equalToConstant: 7.5),
            eventRect.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    func createTopLayer() -> UIView {
        let topLayer = UIView()
        topLayer.isHidden = false
        topLayer.backgroundColor = UIColor(white: 230/255, alpha: 1)
        topLayer.translatesAutoresizingMaskIntoConstraints = false
        return topLayer
    }
    func createEventRect() -> UIView {
        let eventView = UIView()
        eventView.backgroundColor = .systemGray
        eventView.layer.cornerRadius = 3.75
        eventView.clipsToBounds = true
        eventView.translatesAutoresizingMaskIntoConstraints = false
        eventView.isHidden = true
        return eventView
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
