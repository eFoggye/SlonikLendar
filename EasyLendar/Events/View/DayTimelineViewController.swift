import UIKit

final class DayTimelineViewController: UIViewController {
    //MARK: - Constants
    private struct Constants {
        static let hoursInDay: CGFloat = 24
        static let minutesInHours: CGFloat = 60
        static let contentViewHeight: CGFloat = CGFloat(hoursInDay*minutesInHours) + CGFloat(minutesInHours)
        static let eventCornerRaidus: CGFloat = 15
        static let eventLeftPadding: CGFloat = 100
        static let labelLeftPadding: CGFloat = 15
        static let lineHeight: CGFloat = 2
        static let lineTopOffset: CGFloat = 60
        static let labelColor: UIColor = .init(white: 170/255, alpha: 1.0)
        static let lineColor: UIColor = .init(white: 230/255, alpha: 1.0)
    }
    //MARK: - UI Elements
    let scrollView = UIScrollView()
    let contentView = UIView()
    var eventViews = [UIView]()
    //MARK: - Support
    private var viewModel: DayTimelineViewModelProtocol
    private var yCoord: CGFloat = 0
    //MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.makeTitle()
        setUpScrollView()
        setUpDayTimeline()
        bindViewModel()
        viewModel.load()
    }
    //MARK: - View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let maxOffset = scrollView.contentSize.height - scrollView.bounds.height
        let targetOffset = min(max(yCoord - 100, 0), maxOffset)
        scrollView.setContentOffset(CGPoint(x: 0, y: targetOffset), animated: true)
    }
    //MARK: - Init
    init(day: DayModel) {
        self.viewModel = DayTimelineViewModel(day: day)
        super.init(nibName: nil, bundle: nil)
    }
    //MARK: - Create Views
    func setUpScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: Constants.contentViewHeight),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setUpDayTimeline() {
        var hours = [String]()
        for i in 0...23 {
            i < 10 ? hours.append("0\(i):00") : hours.append("\(i):00")
        }
        hours.append("00:00")
        for i in 0...24 {
            let lineView = UIView()
            lineView.backgroundColor = Constants.lineColor
            let hourLabel = UILabel()
            hourLabel.text = hours[i]
            hourLabel.textColor = Constants.labelColor
            lineView.translatesAutoresizingMaskIntoConstraints = false
            lineView.accessibilityIdentifier = "line"
            hourLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(lineView)
            contentView.addSubview(hourLabel)
            
            NSLayoutConstraint.activate([
                hourLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.labelLeftPadding),
                hourLabel.centerYAnchor.constraint(equalTo: lineView.centerYAnchor),
                
                lineView.heightAnchor.constraint(equalToConstant: Constants.lineHeight),
                lineView.leadingAnchor.constraint(equalTo: hourLabel.trailingAnchor, constant: 5),
                lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                lineView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(i+1)*Constants.lineTopOffset)
            ])
        }
    }
    
    func makeEvent() {
        let allDayLabel = createAllDayLabel()
        
        for event in viewModel.events {
            let eventView = EventView(event: event)
            
            eventView.translatesAutoresizingMaskIntoConstraints = false
            eventView.layer.cornerRadius = Constants.eventCornerRaidus
            eventView.onTap = { [weak self] event in
                self?.eventViewTapped(event: event)
            }
            
            eventViews.append(eventView)
            contentView.addSubview(eventView)
            if !event.isAllDay {
                let startY = viewModel.yPosition(date: event.startDate)
                let height = viewModel.height(event: event)
                yCoord = startY + height/2
                NSLayoutConstraint.activate([
                    eventView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: startY),
                    eventView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    eventView.heightAnchor.constraint(equalToConstant: height),
                    eventView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.eventLeftPadding),
                ])
                eventView.isUserInteractionEnabled = true
            } else {
                contentView.addSubview(allDayLabel)
                
                NSLayoutConstraint.activate([
                    eventView.topAnchor.constraint(equalTo: contentView.topAnchor),
                    eventView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    eventView.heightAnchor.constraint(equalToConstant: Constants.minutesInHours),
                    eventView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.eventLeftPadding),
                    
                    allDayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.labelLeftPadding),
                    allDayLabel.topAnchor.constraint(equalTo: eventView.topAnchor),
                    allDayLabel.widthAnchor.constraint(equalToConstant: 50)
                ])
            }
        }
    }
    func createAllDayLabel() -> UILabel {
        let allDayLabel: UILabel = {
            let label = UILabel()
            label.text = "Весь день"
            label.numberOfLines = 2
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = Constants.labelColor
            return label
        }()
        return allDayLabel
    }
    //MARK: - User Actions
    func eventViewTapped(event: Event) {
        let vc = MakeEventViewController(mode: Mode.update(event), minYear: 1000, maxYear: 3000)
        vc.configure(with: event)
        vc.onChange = { [weak self] in
            self?.viewModel.load()
        }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    //MARK: - Helpers
    func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.reloadView()
        }
    }
    
    func reloadView() {
        eventViews.forEach({ $0.removeFromSuperview() })
        eventViews.removeAll()
        makeEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
