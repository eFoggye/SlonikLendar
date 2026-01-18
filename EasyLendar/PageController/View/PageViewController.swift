import UIKit

final class PageViewController: UIPageViewController {
    private var viewModel: PageViewModelProtocol = PageViewModel()
    var controllers: [YearViewController] = []
    //MARK: - Init
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dataSource = self
        delegate = self
        bindViewModel()
        viewModel.makeYears(lowerLimit: 2006, upperLimit: 2046)
        viewModel.addButtonTaped()
        viewModel.onAddEventRequest = { [weak self] in
            guard let vc = self?.createMakeEventViewController() else { return }
            self?.present(vc, animated: true)
        }
    }
    //MARK: - Create Views
    func setUpNavigationBar(year: Int) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 35))
        let label = UILabel(frame: view.bounds)
        label.text = String(year)
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        view.addSubview(label)
        let barbuttonitem = UIBarButtonItem(customView: view)
        navigationItem.leftBarButtonItem = barbuttonitem
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaped))
    }
    //MARK: - Helpers
    func bindViewModel() {
        viewModel.onUpdate = { [weak self] state in
            self?.controllers = state.years.map({ yearModel in
                YearViewController(months: yearModel.months, year: yearModel.year)
            })
            if let controller = self?.controllers[20] {
                self?.setViewControllers([controller], direction: .forward, animated: true)
                self?.setUpNavigationBar(year: controller.year)
            }
        }
    }
    
    func reloadDataInYears() {
        guard let vc = viewControllers?.first as? YearViewController else { return }
        vc.collectionView.reloadData()
    }
    func createMakeEventViewController() -> UINavigationController {
        let vc = MakeEventViewController( mode: Mode.create, minYear: self.controllers.first?.year ?? 0, maxYear: self.controllers.last?.year ?? 0)
        vc.onUpdate = { [weak self] in
            self?.reloadDataInYears()
        }
        vc.onChange = { [weak self] in
            self?.reloadDataInYears()
        }
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
    //MARK: - User Actions
    @objc func addTaped() {
        viewModel.addButtonTaped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

