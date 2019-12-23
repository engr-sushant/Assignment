import UIKit

struct DeliveryItemListConstant {
    static let estimatedRowHeight: CGFloat = 100
    static let cellUniqueIdentifier = "Cell"
}

class DeliveryItemListViewController: UIViewController {

    // MARK: - Variables
    var tableView = UITableView()
    var refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        return refControl
    }()

    var tableFooterLoader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.gray)
        loader.hidesWhenStopped = true
        return loader
    }()
    
    var viewModel = DeliveryItemViewModel()
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupTableView()
        self.layoutTableView()
        self.setupCompletionHandlers()
        self.viewModel.loadData(withLoader: .APICallingLoader)
    }
    
    // MARK: - Setup Navigation Bar
    func setupNavigationBar() {
        self.title = LocalizedString.DELIVERYITEMSVCTITLE
    }
    
    // MARK: - Setup Table View
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DeliveryItemCell.self, forCellReuseIdentifier: DeliveryItemListConstant.cellUniqueIdentifier)
        tableView.separatorStyle = .none
        tableView.tableFooterView = tableFooterLoader
        refreshControl.addTarget(self, action: #selector(self.refreshTableViewData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    // MARK: - Add Constraints To TableView
    func layoutTableView() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
        
        let cornerAnchorForTableView = ConrnerAnchor(top: (self.topLayoutGuide.bottomAnchor, ViewConstraintConstants.zeroPaddingConstant),
                                                   bottom: (self.bottomLayoutGuide.topAnchor, ViewConstraintConstants.zeroPaddingConstant),
                                                   left: (self.view.leftAnchor, ViewConstraintConstants.zeroPaddingConstant),
                                                   right: (self.view.rightAnchor, ViewConstraintConstants.zeroPaddingConstant)
        )
        tableView.addConstraints(cornerConstraints: cornerAnchorForTableView,
                               centerY: nil,
                               centerX: nil,
                               height: ViewConstraintConstants.zeroPaddingConstant,
                               width: ViewConstraintConstants.zeroPaddingConstant
        )
    }
    
    // MARK: - Setup Completion Handlers
    func setupCompletionHandlers() {
        self.handleCompletionWithSuccess()
        self.handleCompletionWithNoData()
        self.handleCompletionWithError()
        self.handleInternetError()
        self.handleNextPageLoading()
    }
    
    // MARK: - Handle Completion With Success
    func handleCompletionWithSuccess() {
        viewModel.handleCompletionWithSuccess = {[weak self] loaderType in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.stopProgressLoader(withLoader: loaderType)
            }
        }
    }
    
    // MARK: - Handle Completion With No Data
    func handleCompletionWithNoData() {
        viewModel.handleCompletionWithNoData = {[weak self] loaderType in
            DispatchQueue.main.async {
                CommonClass.shared.showToastWithTitle(messageBody: LocalizedString.NORESULTFOUND, onViewController: self)
                self?.stopProgressLoader(withLoader: loaderType)
            }
        }
    }
    
    // MARK: - Handle Completion with Error
    func handleCompletionWithError() {
        viewModel.handleCompletionWithError = {[weak self] (loaderType, error) in
            DispatchQueue.main.async {
                CommonClass.shared.showToastWithTitle(messageBody: error.localizedDescription, onViewController: self)
                self?.stopProgressLoader(withLoader: loaderType)
            }
        }
    }
    
    // MARK: - Handle Internet error
    func handleInternetError() {
        viewModel.handleInternetError = {[weak self] loaderType in
            DispatchQueue.main.async {
                CommonClass.shared.showToastWithTitle(messageBody: LocalizedString.NOINTERNETCONNECTION, onViewController: self)
                self?.stopProgressLoader(withLoader: loaderType)
            }
        }
    }
    
    // MARK: - Completion Next Page Loading
    func handleNextPageLoading() {
        viewModel.handleNextPageLoading = {[weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.tableFooterView?.isHidden = false
                self?.tableFooterLoader.startAnimating()
            }
        }
    }
    
    // MARK: - Refresh Table View Data
    @objc func refreshTableViewData() {
        viewModel.refreshData(withLoader: .PullToRefreshLoader)
    }
    
    // MARK: - Stop Progress Loader
    func stopProgressLoader(withLoader loaderType: ProgressLoaderType) {
        DispatchQueue.main.async {
            switch loaderType {
            case .APICallingLoader:
                CommonClass.shared.hideLoader()
            case .PullToRefreshLoader:
                self.refreshControl.endRefreshing()
            case .BottomDraggingLoader:
                self.tableFooterLoader.stopAnimating()
            }
        }
    }
    
    // MARK: - Navigate to Delivery Item Detail Screen
    func navigateToDeliveryItemDetail(withItemDetailVM itemDetailVM: DeliveryDetailViewModel) {
        let itemDetailVC = DeliveryDetailViewController.init(itemDetailVM)
        self.navigationController?.pushViewController(itemDetailVC, animated: true)
    }
}

// MARK: - Extension For Table View Delegate And Datasource Methods
extension DeliveryItemListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return DeliveryItemListConstant.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.deliveries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryItemListConstant.cellUniqueIdentifier, for: indexPath) as! DeliveryItemCell
        cell.plotDataOnCell(withCellItem: viewModel.deliveries[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = self.viewModel.getDeliveryDetailViewModel(fromIndex: indexPath.row) {
            self.navigateToDeliveryItemDetail(withItemDetailVM: viewModel)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxHght = tableView.contentSize.height - self.tableView.bounds.size.height
        viewModel.checkBottomDragging(tblOffset: tableView.contentOffset.y, maxHght: maxHght)
    }
}
