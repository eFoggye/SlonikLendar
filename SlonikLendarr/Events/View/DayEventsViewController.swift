import UIKit

class DayEventsViewController: UIViewController {
    let scrollView = UIScrollView()
    let contentView = UIView()
    private var day: DayModel
    private let viewModel: DayEventsViewModel
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.makeTitle()
        createScrollView()
        setUpLines()
        bind()
        viewModel.load()
    }
    init(day: DayModel) {
        self.day = day
        self.viewModel = DayEventsViewModel(day: day)
        super.init(nibName: nil, bundle: nil)
    }
    func bind() {
        viewModel.onUpdate = { [weak self] in
            self?.reload()
        }
    }
    func createScrollView() {
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
            contentView.heightAnchor.constraint(equalToConstant: 24 * 60),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func setUpLines() {
        var hours = [String]()
        for i in 0...23 {
            i < 10 ? hours.append("0\(i):00") : hours.append("\(i):00")
        }
        for i in 0...23 {
            let lineView = UIView()
            lineView.backgroundColor = .systemGray5
            let hourLabel = UILabel()
            hourLabel.text = hours[i]
            hourLabel.textColor = .systemGray3
            lineView.translatesAutoresizingMaskIntoConstraints = false
            hourLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(lineView)
            contentView.addSubview(hourLabel)
            
            NSLayoutConstraint.activate([
                hourLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
                hourLabel.centerYAnchor.constraint(equalTo: lineView.centerYAnchor),
                
                lineView.heightAnchor.constraint(equalToConstant: 2),
                lineView.leadingAnchor.constraint(equalTo: hourLabel.trailingAnchor, constant: 5),
                lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                lineView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(i+1)*60)
            ])
        }
    }
    func makeEvent() {
        for event in viewModel.events {
            let eventView = EventView(event: event)
            
            eventView.translatesAutoresizingMaskIntoConstraints = false
            let startY = viewModel.yPosition(date: event.startDate)
            let height = viewModel.height(event: event)
            eventView.layer.cornerRadius = 15
            eventView.onTap = { [weak self] event in
                self?.eventViewTapped(event: event)
            }
            contentView.addSubview(eventView)
            NSLayoutConstraint.activate([
                eventView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(startY)),
                eventView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                eventView.heightAnchor.constraint(equalToConstant: CGFloat(height)),
                eventView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 100),
            ])
            eventView.isUserInteractionEnabled = true
        }
    }
    func eventViewTapped(event: Event) {
        let vc = MakeEventViewController(minYear: 1000, maxYear: 3000)
        vc.nameTextField.text = event.name
        vc.startDatePicker.date = event.startDate
        vc.startTimePicker.date = event.startDate
        vc.endDatePicker.date = event.endDate
        vc.endTimePicker.date = event.endDate
        vc.allDaySwitch.isOn = event.isAllDay
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func reload() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        setUpLines()
        makeEvent()
    }
}
