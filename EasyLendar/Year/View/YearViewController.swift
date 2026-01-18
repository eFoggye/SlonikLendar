import UIKit

final class YearViewController: UIViewController {

    lazy var collectionView = makeCollectionView()
    private let weekdaysNavigation = WeekdaysNavigationView()
    let refresh = UIRefreshControl()

    let helper: CalendarHelperProtocol
    //TODO: private let APImanager: APIManagerProtocol
    let viewModel: YearViewModelProtocol
    

    var months = [MonthModel]()
    var year = 0
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addSubview(weekdaysNavigation)
        setupSettingsForRefreshControl()
        setUpConstraints()
    }
    //MARK: - Init
    init(
        months: [MonthModel],
        year: Int,
        helper: CalendarHelperProtocol = CalendarHelper(),
        APImanager: APIManagerProtocol = APIManager(),
        viewModel: YearViewModelProtocol = YearViewModel()
    ) {
        self.months = months
        self.year = year
        self.helper = helper
        //TODO: self.APImanager = APImanager
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    //MARK: - Create Views
    func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CompositionalLayout.makeCompositionalLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: DayCell.identifier)
        collectionView.register(MonthReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MonthReusableView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }
    
    //MARK: - Set Up Constraints
    func setUpConstraints() {
        weekdaysNavigation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weekdaysNavigation.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weekdaysNavigation.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weekdaysNavigation.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weekdaysNavigation.heightAnchor.constraint(equalToConstant: 20),
            
            collectionView.topAnchor.constraint(equalTo: weekdaysNavigation.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    //MARK: - Help
    func setupSettingsForRefreshControl() {
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refresh
    }
    //MARK: - User Actions
    @objc func refreshData() {
        collectionView.reloadData()
        refresh.endRefreshing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

