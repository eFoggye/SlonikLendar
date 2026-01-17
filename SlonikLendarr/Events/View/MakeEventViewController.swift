import UIKit

class MakeEventViewController: UIViewController {
    private lazy var infoBlock = makeInfoBlockView()
    private lazy var timeIntervalBlock = makeTimeIntervalBlockView()
    private lazy var notificationsBlock = makeNotificationsBlock()
    lazy var startDatePicker = createDatePicker()
    lazy var endDatePicker = createDatePicker()
    lazy var startTimePicker = createTimePicker()
    lazy var endTimePicker = createTimePicker()
    lazy var allDaySwitch = createSwitch()
    lazy var notificationSwitch = createSwitch()
    let nameTextField = UITextField()
    private let viewModel = MakeEventViewModel()
    private var minimumYear = 0
    private var maximumYear = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        infoBlock.backgroundColor = .white
        timeIntervalBlock.backgroundColor = .white
        notificationsBlock.backgroundColor = .white
        view.addSubview(infoBlock)
        view.addSubview(timeIntervalBlock)
        view.addSubview(notificationsBlock)
        setUpConstraints()
        title = "Make event"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(leftBarButtonItemTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(rightBarButtonItemTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false
        nameTextField.addTarget(self, action: #selector(nameTextFieldValueChanged), for: .editingChanged)
    }
    init(minYear: Int, maxYear: Int) {
        self.maximumYear = maxYear
        self.minimumYear = minYear
        super.init(nibName: nil, bundle: nil)
    }
    //MARK: - Info Block
    func makeInfoBlockView() -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 15
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.15
        container.layer.shadowOffset = .zero
        container.layer.shadowRadius = 10
        container.translatesAutoresizingMaskIntoConstraints = false

        nameTextField.borderStyle = .none
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.textColor = .black

        let descriptionTextField = UITextField()
        descriptionTextField.borderStyle = .none
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.textColor = .black
        
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Название",
            attributes: [
                .foregroundColor: UIColor.systemGray
            ]
        )
        descriptionTextField.attributedPlaceholder = NSAttributedString(
            string: "Описание",
            attributes: [
                .foregroundColor: UIColor.systemGray
            ]
        )

        [nameTextField, descriptionTextField].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addLeftPadding(textField: $0)
        }

        let separator = UIView()
        separator.backgroundColor = .separator
        separator.translatesAutoresizingMaskIntoConstraints = false

        let infoBlock = UIStackView(arrangedSubviews: [
            nameTextField,
            separator,
            descriptionTextField
        ])
        infoBlock.axis = .vertical
        infoBlock.spacing = 0
        infoBlock.distribution = .fill
        infoBlock.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(infoBlock)
        NSLayoutConstraint.activate([
            infoBlock.topAnchor.constraint(equalTo: container.topAnchor),
            infoBlock.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            infoBlock.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
            infoBlock.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 50),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
        return container
    }
    //MARK: - Notification Block
    func makeNotificationsBlock() -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 15
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.15
        container.layer.shadowOffset = .zero
        container.layer.shadowRadius = 10
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let notificationsLabel = createLabel(with: "Уведомления")
        notificationsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(notificationsLabel)
        container.addSubview(notificationSwitch)
        
        NSLayoutConstraint.activate([
            notificationsLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            notificationsLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            
            notificationSwitch.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
            notificationSwitch.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
        
        return container
    }
    //MARK: - Constraints
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            infoBlock.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            infoBlock.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoBlock.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            timeIntervalBlock.topAnchor.constraint(equalTo: infoBlock.bottomAnchor, constant: 50),
            timeIntervalBlock.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timeIntervalBlock.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timeIntervalBlock.heightAnchor.constraint(equalToConstant: 150),
            
            notificationsBlock.topAnchor.constraint(equalTo: timeIntervalBlock.bottomAnchor, constant: 30),
            notificationsBlock.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notificationsBlock.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            notificationsBlock.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    //MARK: - Time interval block
    func makeTimeIntervalBlockView() -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 15
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.15
        container.layer.shadowOffset = .zero
        container.layer.shadowRadius = 10
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let allDayLabel = createLabel(with: "Весь день")
        let startLabel = createLabel(with: "Начало")
        let endLabel = createLabel(with: "Конец")
        
        let firstSeparator = createSeparator()
        let secondSeparator = createSeparator()
        
        allDayLabel.translatesAutoresizingMaskIntoConstraints = false
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        startTimePicker.translatesAutoresizingMaskIntoConstraints = false
        endTimePicker.translatesAutoresizingMaskIntoConstraints = false
        
        allDaySwitch.translatesAutoresizingMaskIntoConstraints = false
        
        endDatePicker.minimumDate = startDatePicker.date
        startDatePicker.minimumDate = Date.now
        endTimePicker.minimumDate = Calendar.current.date(
            byAdding: .minute,
            value: 5,
            to: startDateTime()
        )
        startDatePicker.addTarget(self, action: #selector(startPickerValueChanged), for: .valueChanged)
        startTimePicker.addTarget(self, action: #selector(startPickerValueChanged), for: .valueChanged)
        allDaySwitch.addTarget(self, action: #selector(allDaySwitchValueChanged), for: .valueChanged)
        
        container.addSubview(allDayLabel)
        container.addSubview(allDaySwitch)
        container.addSubview(startLabel)
        container.addSubview(endLabel)
        container.addSubview(startDatePicker)
        container.addSubview(endDatePicker)
        container.addSubview(startTimePicker)
        container.addSubview(endTimePicker)
        container.addSubview(firstSeparator)
        container.addSubview(secondSeparator)
        
        NSLayoutConstraint.activate([
            allDayLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            allDayLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            allDaySwitch.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
            allDaySwitch.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            
            firstSeparator.topAnchor.constraint(equalTo: allDayLabel.bottomAnchor, constant: 5),
            firstSeparator.heightAnchor.constraint(equalToConstant: 1),
            firstSeparator.leadingAnchor.constraint(equalTo: startLabel.leadingAnchor),
            firstSeparator.trailingAnchor.constraint(equalTo: endTimePicker.trailingAnchor),
            
            startLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            startLabel.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor, constant: 12),
            startTimePicker.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
            startTimePicker.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor, constant: 5),
            startDatePicker.trailingAnchor.constraint(equalTo: startTimePicker.leadingAnchor, constant: -5),
            startDatePicker.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor, constant: 5),
            
            endLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            endLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            endTimePicker.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
            endTimePicker.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5),
            endDatePicker.trailingAnchor.constraint(equalTo: endTimePicker.leadingAnchor, constant: -5),
            endDatePicker.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5),
            
            secondSeparator.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 5),
            secondSeparator.heightAnchor.constraint(equalToConstant: 1),
            secondSeparator.leadingAnchor.constraint(equalTo: startLabel.leadingAnchor),
            secondSeparator.trailingAnchor.constraint(equalTo: endTimePicker.trailingAnchor)
        ])
        return container
    }
    //MARK: - Help functions
    private func addLeftPadding(textField: UITextField) {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftView = padding
        textField.leftViewMode = .always
    }
    private func createLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    private func createDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        var dateComponents = DateComponents()
        dateComponents.year = self.minimumYear
        datePicker.minimumDate = Calendar.current.date(from: dateComponents)
        dateComponents.year = self.maximumYear
        datePicker.maximumDate = Calendar.current.date(from: dateComponents)
        datePicker.backgroundColor = .systemGray
        datePicker.layer.cornerRadius = 18
        datePicker.clipsToBounds = true
        return datePicker
    }
    private func createTimePicker() -> UIDatePicker {
        let timePicker = UIDatePicker()
        timePicker.preferredDatePickerStyle = .compact
        timePicker.datePickerMode = .time
        timePicker.backgroundColor = .systemGray
        timePicker.layer.cornerRadius = 18
        timePicker.clipsToBounds = true
        timePicker.minuteInterval = 5
        return timePicker
    }
    private func createSwitch() -> UISwitch {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.preferredStyle = .automatic
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.tintColor = .systemGray
        toggle.backgroundColor = .systemGray
        toggle.layer.cornerRadius = 14
        toggle.clipsToBounds = true
        return toggle
    }
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }
    private func startDateTime() -> Date {
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents(
            [.year, .month, .day],
            from: startDatePicker.date
        )
        
        let timeComponents = calendar.dateComponents(
            [.hour, .minute],
            from: startTimePicker.date
        )
        
        var components = DateComponents()
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        
        return calendar.date(from: components)!
    }
    private func endDateTime() -> Date {
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents(
            [.year, .month, .day],
            from: endDatePicker.date
        )
        
        let timeComponents = calendar.dateComponents(
            [.hour, .minute],
            from: endTimePicker.date
        )
        
        var components = DateComponents()
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        
        return calendar.date(from: components)!
    }
    private func timePickersEnabled(flag: Bool) {
        startTimePicker.isEnabled = flag
        endTimePicker.isEnabled = flag
        startTimePicker.alpha = flag ? 1 : 0.4
        endTimePicker.alpha = flag ? 1 : 0.4
    }
    @objc func startPickerValueChanged() {
        let isSameDay = Calendar.current.isDate(startDatePicker.date, inSameDayAs: endDatePicker.date)
        let isToday = Calendar.current.isDateInToday(startDatePicker.date)

        startTimePicker.minimumDate = (isSameDay && isToday) ? Date() : nil
        if allDaySwitch.isOn {
            let startDate = startDateTime()
            let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
            endDatePicker.setDate(endDate, animated: true)
        } else {
            timePickersEnabled(flag: true)
            endDatePicker.minimumDate = startDatePicker.date
        }
        if endDateTime() < startDateTime() {
            endTimePicker.setDate(
                Calendar.current.date(byAdding: .hour, value: 1, to: startDateTime())!,
                animated: true
            )
        }
        endTimePicker.minimumDate = Calendar.current.date(
            byAdding: .minute,
            value: 5,
            to: startDateTime()
        )
    }
    @objc func allDaySwitchValueChanged() {
        if allDaySwitch.isOn {
            startDatePicker.setDate(Calendar.current.startOfDay(for: startDatePicker.date), animated: true)
            startTimePicker.setDate(Calendar.current.startOfDay(for: startDatePicker.date), animated: true)
            let startDate = startDateTime()
            let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
            endDatePicker.setDate(endDate, animated: true)
            endTimePicker.setDate(endDate, animated: true)
            timePickersEnabled(flag: false)
        } else {
            timePickersEnabled(flag: true)
        }
    }
    @objc func leftBarButtonItemTapped() {
        dismiss(animated: true)
    }
    @objc func rightBarButtonItemTapped() {
        let event = Event(id: UUID(), name: nameTextField.text ?? "", startDate: startDateTime(), endDate: endDateTime(), isAllDay: allDaySwitch.isOn, notifications: notificationSwitch.isOn)
        viewModel.save(event: event)
        dismiss(animated: true)
    }
    @objc func nameTextFieldValueChanged () {
        if nameTextField.text?.count == 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
