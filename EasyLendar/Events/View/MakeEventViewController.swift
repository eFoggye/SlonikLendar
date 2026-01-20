import UIKit

final class MakeEventViewController: UIViewController {
    //MARK: - Constants
    private struct Constants {
        static let nameTextFieldPlaceholder = "Название"
        static let descriptionTextFieldPlaceholder = "Описание"
        static let notificationLabel = "Уведомления"
        static let allDayLabel = "Весь день"
        static let startLabel = "Начало"
        static let endLabel = "Конец"
        static let deleteButtonTitle = "Удалить событие"
        static let alertTitle = "Уведомления отключены"
        static let alertMessage = "Чтобы получать напоминания, включите уведомления в настройках"
        static let allowActionText = "Настройки"
        static let dontAllowActionText = "Пропустить"
        static let title = "Make event"
        static let chevronImage = "chevron.down"
        static let containerCornerRadius: CGFloat = 15
        static let containerShadowRadius: CGFloat = 10
        static let infoBlockSpacing: CGFloat = 0
        static let boldSystemFontSize: CGFloat = 25
        static let pickerCornerRadius: CGFloat = 18
        static let switchCornerRadius: CGFloat = 14
        static let disabledAlpha: CGFloat = 0.4
        static let containerShadowOpacity: Float = 0.15
        static let timePickerMinuteInterval = 5
        static let textFieldLeftPadding = 8
        static let deleteButtonTopOffset: CGFloat = 150
        static let defaultHorizontalOffset: CGFloat = 20
        static let defaultVerticalOffset: CGFloat = 12
        static let defaultPickerVerticalOffset: CGFloat = 5
        static let defaultPickerHorizontalOffset: CGFloat = 5
        static let background = UIColor.white
        static let shadow = UIColor.black.cgColor
        static let font = UIColor.black
        static let placeholder = UIColor.systemGray
        static let picker = UIColor.systemGray
        static let toggle = UIColor.systemGray
        static let countOfMinutes: Double = 60
    }
    //MARK: - UI Info Blocks
    private lazy var infoBlock = makeInfoBlockView()
    private lazy var timeIntervalBlock = makeTimeIntervalBlockView()
    private lazy var notificationsBlock = makeNotificationsBlock()
    //MARK: - UI Elements
    private lazy var startDatePicker = createDatePicker()
    private lazy var endDatePicker = createDatePicker()
    private lazy var startTimePicker = createTimePicker()
    private lazy var endTimePicker = createTimePicker()
    private lazy var allDaySwitch = createSwitch()
    private lazy var notificationSwitch = createSwitch()
    private let nameTextField = UITextField()
    private let descriptionTextField = UITextField()
    private let deleteButton = UIButton()
    //MARK: - Support
    private let notificationManager: NotificationManagerProtocol
    private let viewModel: MakeEventViewModelProtocol
    //MARK: - State
    var onUpdate: (() -> Void)?
    var onChange: (() -> Void)?
    private var minimumYear = 0
    private var maximumYear = 0
    private var mode: Mode
    //MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.background
        
        view.addSubview(infoBlock)
        view.addSubview(timeIntervalBlock)
        view.addSubview(notificationsBlock)
        
        setUpConstraints()
        configureNavigationBar()
        
        if case .update = mode {
            createDeleteButton()
        }
        
    }
    //MARK: - Init
    init(
        mode: Mode,
        minYear: Int,
        maxYear: Int,
        viewModel: MakeEventViewModelProtocol = MakeEventViewModel(),
        notificationManager: NotificationManagerProtocol = NotificationManager.shared
    ) {
        self.maximumYear = maxYear
        self.minimumYear = minYear
        self.mode = mode
        self.notificationManager = notificationManager
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    //MARK: - Info Block
    private func makeInfoBlockView() -> UIView {
        let container = createContainer()
        
        nameTextField.borderStyle = .none
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.textColor = Constants.font
        nameTextField.addTarget(self, action: #selector(nameTextFieldValueChanged), for: .editingChanged)
        nameTextField.returnKeyType = .continue
        nameTextField.delegate = self
        
        descriptionTextField.borderStyle = .none
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.textColor = Constants.font
        descriptionTextField.returnKeyType = .done
        descriptionTextField.delegate = self
        
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: Constants.nameTextFieldPlaceholder,
            attributes: [
                .foregroundColor: Constants.placeholder
            ]
        )
        descriptionTextField.attributedPlaceholder = NSAttributedString(
            string: Constants.descriptionTextFieldPlaceholder,
            attributes: [
                .foregroundColor: Constants.placeholder
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
        infoBlock.spacing = Constants.infoBlockSpacing
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
    private func makeNotificationsBlock() -> UIView {
        let container = createContainer()
        
        let notificationsLabel = createLabel(with: Constants.notificationLabel)
        notificationsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(notificationsLabel)
        container.addSubview(notificationSwitch)
        
        NSLayoutConstraint.activate([
            notificationsLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            notificationsLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.defaultHorizontalOffset),
            
            notificationSwitch.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
            notificationSwitch.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
        
        return container
    }
    //MARK: - Time interval block
    private func makeTimeIntervalBlockView() -> UIView {
        let container = createContainer()
        
        let allDayLabel = createLabel(with: Constants.allDayLabel)
        let startLabel = createLabel(with: Constants.startLabel)
        let endLabel = createLabel(with: Constants.endLabel)
        
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
        
        let roundedNow = roundToNextFiveMinutes(date: Date())

        startDatePicker.minimumDate = roundedNow
        startDatePicker.setDate(roundedNow, animated: false)

        startTimePicker.setDate(roundedNow, animated: false)

        let end = defaultEndDate(start: roundedNow)
        endDatePicker.setDate(end, animated: false)
        endTimePicker.setDate(end, animated: false)

        endTimePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 5, to: roundedNow)
        endDatePicker.minimumDate = roundedNow
        
        startDatePicker.addTarget(self, action: #selector(startDatePickerValueChanged), for: .valueChanged)
        startTimePicker.addTarget(self, action: #selector(startDatePickerValueChanged), for: .valueChanged)
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
            allDayLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.defaultHorizontalOffset),
            allDayLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: Constants.defaultVerticalOffset),
            allDaySwitch.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
            allDaySwitch.topAnchor.constraint(equalTo: container.topAnchor, constant: Constants.defaultVerticalOffset),
            
            firstSeparator.topAnchor.constraint(equalTo: allDayLabel.bottomAnchor, constant: 5),
            firstSeparator.heightAnchor.constraint(equalToConstant: 1),
            firstSeparator.leadingAnchor.constraint(equalTo: startLabel.leadingAnchor),
            firstSeparator.trailingAnchor.constraint(equalTo: endTimePicker.trailingAnchor),
            
            startLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.defaultHorizontalOffset),
            startLabel.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor, constant: Constants.defaultVerticalOffset),
            startTimePicker.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
            startTimePicker.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor, constant: Constants.defaultPickerVerticalOffset),
            startDatePicker.trailingAnchor.constraint(equalTo: startTimePicker.leadingAnchor, constant: -Constants.defaultPickerHorizontalOffset),
            startDatePicker.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor, constant: Constants.defaultPickerVerticalOffset),
            
            endLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.defaultHorizontalOffset),
            endLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Constants.defaultVerticalOffset),
            endTimePicker.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
            endTimePicker.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Constants.defaultPickerVerticalOffset),
            endDatePicker.trailingAnchor.constraint(equalTo: endTimePicker.leadingAnchor, constant: -Constants.defaultPickerHorizontalOffset),
            endDatePicker.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Constants.defaultPickerVerticalOffset),
            
            secondSeparator.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 5),
            secondSeparator.heightAnchor.constraint(equalToConstant: 1),
            secondSeparator.leadingAnchor.constraint(equalTo: startLabel.leadingAnchor),
            secondSeparator.trailingAnchor.constraint(equalTo: endTimePicker.trailingAnchor)
        ])
        return container
    }
    //MARK: - Set Up Constraints
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            infoBlock.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            infoBlock.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultHorizontalOffset),
            infoBlock.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultHorizontalOffset),
            
            timeIntervalBlock.topAnchor.constraint(equalTo: infoBlock.bottomAnchor, constant: 50),
            timeIntervalBlock.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultHorizontalOffset),
            timeIntervalBlock.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultHorizontalOffset),
            timeIntervalBlock.heightAnchor.constraint(equalToConstant: 150),
            
            notificationsBlock.topAnchor.constraint(equalTo: timeIntervalBlock.bottomAnchor, constant: 30),
            notificationsBlock.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultHorizontalOffset),
            notificationsBlock.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultHorizontalOffset),
            notificationsBlock.heightAnchor.constraint(equalToConstant: 50),
            
            
        ])
    }
    //MARK: - Create Views
    private func createLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: Constants.boldSystemFontSize)
        label.textColor = Constants.font
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
        datePicker.backgroundColor = Constants.picker
        datePicker.layer.cornerRadius = Constants.pickerCornerRadius
        datePicker.clipsToBounds = true
        return datePicker
    }
    
    private func createTimePicker() -> UIDatePicker {
        let timePicker = UIDatePicker()
        timePicker.preferredDatePickerStyle = .compact
        timePicker.datePickerMode = .time
        timePicker.backgroundColor = Constants.picker
        timePicker.layer.cornerRadius = Constants.pickerCornerRadius
        timePicker.clipsToBounds = true
        timePicker.minuteInterval = Constants.timePickerMinuteInterval
        return timePicker
    }
    
    private func createSwitch() -> UISwitch {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.preferredStyle = .automatic
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.tintColor = Constants.toggle
        toggle.backgroundColor = Constants.toggle
        toggle.layer.cornerRadius = Constants.switchCornerRadius
        toggle.clipsToBounds = true
        return toggle
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }
    
    private func createContainer() -> UIView{
        let container = UIView()
        container.layer.cornerRadius = Constants.containerCornerRadius
        container.layer.shadowColor = Constants.shadow
        container.layer.shadowOpacity = Constants.containerShadowOpacity
        container.layer.shadowOffset = .zero
        container.layer.shadowRadius = Constants.containerShadowRadius
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = Constants.background
        return container
    }
    private func createDeleteButton () {
        deleteButton.backgroundColor = .clear
        deleteButton.setTitle(Constants.deleteButtonTitle, for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.topAnchor.constraint(equalTo: notificationsBlock.bottomAnchor, constant: Constants.deleteButtonTopOffset)
        ])
    }
    
    private func showAlertController() {
        let alertController = UIAlertController(
            title: Constants.alertTitle,
            message: Constants.alertMessage,
            preferredStyle: .alert
        )
        let allowAction = UIAlertAction(title: Constants.allowActionText, style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        let dontAllowAction = UIAlertAction(title: Constants.dontAllowActionText, style: .cancel)
        alertController.addAction(dontAllowAction)
        alertController.addAction(allowAction)
        
        present(alertController, animated: true)
    }
    //MARK: - Configure
    private func configureNavigationBar() {
        title = Constants.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: Constants.chevronImage),
            style: .plain,
            target: self,
            action: #selector(leftBarButtonItemTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(rightBarButtonItemTapped)
        )
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func configure(with event: Event) {
        nameTextField.text = event.name
        startDatePicker.date = event.startDate
        startTimePicker.date = event.startDate
        endDatePicker.date = event.endDate
        endTimePicker.date = event.endDate
        allDaySwitch.isOn = event.isAllDay
        notificationSwitch.isOn = event.notifications
    }
    //MARK: - Actions
    @objc func startDatePickerValueChanged() {
        let start = roundToNextFiveMinutes(
            date: viewModel.startDateTime(
                    startDate: startDatePicker.date,
                    startTime: startTimePicker.date
                )
            )

            startDatePicker.setDate(start, animated: false)
            startTimePicker.setDate(start, animated: false)

            let minEnd = Calendar.current.date(byAdding: .minute, value: 5, to: start)!
            endTimePicker.minimumDate = minEnd
            endDatePicker.minimumDate = start

            let currentEnd = viewModel.endDateTime(
                endDate: endDatePicker.date,
                endTime: endTimePicker.date
            )

            if currentEnd < minEnd {
                let fixedEnd = defaultEndDate(start: start)
                endDatePicker.setDate(fixedEnd, animated: true)
                endTimePicker.setDate(fixedEnd, animated: true)
            }
    }
    
    @objc private func allDaySwitchValueChanged() {
        if allDaySwitch.isOn {
            let startDateTime = viewModel.startDateTime(startDate: startDatePicker.date, startTime: startTimePicker.date)
            startTimePicker.setDate(Calendar.current.startOfDay(for: startDateTime), animated: true)
            let endDate = Calendar.current.date(bySettingHour: 23, minute: 55, second: 0, of: startDateTime)!
            endDatePicker.setDate(endDate, animated: true)
            endTimePicker.setDate(endDate, animated: true)
            timePickersEnabled(flag: false)
        } else {
            timePickersEnabled(flag: true)
        }
    }
    
    @objc private func nameTextFieldValueChanged () {
        if !nameTextField.hasText {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    //MARK: - User Actions
    @objc private func leftBarButtonItemTapped() {
        dismiss(animated: true)
    }
    
    @objc private func rightBarButtonItemTapped() {
        let startDateTime = viewModel.startDateTime(startDate: startDatePicker.date, startTime: startTimePicker.date)
        let endDateTime = viewModel.endDateTime(endDate: endDatePicker.date, endTime: endTimePicker.date)
        switch mode {
        case .create:
            let event = Event(
                id: UUID(),
                name: nameTextField.text ?? "",
                startDate: startDateTime,
                endDate: endDateTime,
                isAllDay: allDaySwitch.isOn,
                notifications: notificationSwitch.isOn
            )
            viewModel.save(event: event)
            onUpdate?()
            guard notificationSwitch.isOn else {
                dismiss(animated: true)
                return
            }
            handleNotificationsIfNeeded()
        case .update(let oldEvent):
            let updatedEvent = Event(
                id: oldEvent.id,
                name: nameTextField.text ?? "",
                startDate: startDateTime,
                endDate: endDateTime,
                isAllDay: allDaySwitch.isOn,
                notifications: notificationSwitch.isOn
            )
            viewModel.update(event: updatedEvent)
            onChange?()
            handleNotificationsIfNeeded()
        }
    }
    @objc private func deleteButtonTapped() {
        if case .update(let event) = mode {
            viewModel.delete(event: event)
            onChange?()
            onUpdate?()
            dismiss(animated: true)
        }
    }
    //MARK: - Helpers
    private func addLeftPadding(textField: UITextField) {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: Constants.textFieldLeftPadding, height: 0))
        textField.leftView = padding
        textField.leftViewMode = .always
    }
    private func timePickersEnabled(flag: Bool) {
        startTimePicker.isEnabled = flag
        endTimePicker.isEnabled = flag
        startTimePicker.alpha = flag ? 1 : Constants.disabledAlpha
        endTimePicker.alpha = flag ? 1 : Constants.disabledAlpha
    }
    private func handleNotificationsIfNeeded() {
        notificationManager.checkAuthorizationStatus { [weak self] status in
            DispatchQueue.main.async {
                if status == .denied {
                    self?.showAlertController()
                } else {
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func roundToNextFiveMinutes(date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )

        guard let minute = components.minute else { return date }
        let roundedMinute = ((minute + 4) / 5) * 5

        if roundedMinute >= 60 {
            components.hour = (components.hour ?? 0) + 1
            components.minute = 0
        } else {
            components.minute = roundedMinute
        }

        components.second = 0
        return calendar.date(from: components) ?? date
    }

    private func defaultEndDate(start: Date) -> Date {
        Calendar.current.date(byAdding: .hour, value: 1, to: start) ?? start
    }
}
//MARK: - UI Text Field Delegate
extension MakeEventViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            descriptionTextField.becomeFirstResponder()
        case descriptionTextField:
            descriptionTextField.resignFirstResponder()
        default: break
        }
        return true
    }
}
