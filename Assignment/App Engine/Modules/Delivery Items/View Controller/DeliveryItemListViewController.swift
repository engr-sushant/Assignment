import UIKit

class DeliveryItemListViewController: UIViewController {

    // MARK: - Constants
    let estimatedRowHeight: CGFloat = 100
    let cellUniqueIdentifier = "Cell"

    // MARK: - Variables
    var tableView = UITableView()
    var refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        return refControl
    }()

    var tableFooterLoader : UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.gray)
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
        self.viewModel.loadData()
    }
    
    // MARK: - Setup Navigation Bar
    func setupNavigationBar() {
        self.title = LocalizedString.DELIVERYITEMSVCTITLE
    }
    
    // MARK: - Setup Table View
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DeliveryItemCell.self, forCellReuseIdentifier: cellUniqueIdentifier)
        tableView.separatorStyle = .none
        tableView.tableFooterView = tableFooterLoader
        refreshControl.addTarget(self, action: #selector(self.refreshTableViewData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    // MARK: - Add Constraints To TableView
    func layoutTableView() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
        
        //Adding constraint to Map View
        let cornerAnchorForTableView = ConrnerAnchor(top    : (self.topLayoutGuide.bottomAnchor, ViewRelatedConstants.zeroPaddingConstant),
                                                   bottom   : (self.bottomLayoutGuide.topAnchor, ViewRelatedConstants.zeroPaddingConstant),
                                                   left     : (self.view.leftAnchor, ViewRelatedConstants.zeroPaddingConstant),
                                                   right    : (self.view.rightAnchor, ViewRelatedConstants.zeroPaddingConstant)
        )
        tableView.addConstraints(cornerConstraints: cornerAnchorForTableView,
                               centerY  : nil,
                               centerX  : nil,
                               height   : ViewRelatedConstants.zeroPaddingConstant,
                               width    : ViewRelatedConstants.zeroPaddingConstant
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
        viewModel.handleCompletionWithSuccess = {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
                self?.updateLoader()
            }
        }
    }
    
    // MARK: - Handle Completion With No Data
    func handleCompletionWithNoData() {
        viewModel.handleCompletionWithNoData = {[weak self] in
            DispatchQueue.main.async {
                CommonClass.shared.showAlertWithTitle(messageBody: LocalizedString.NORESULTFOUND, okBlock: {
                    self?.updateLoader()
                })
            }
        }
    }
    
    // MARK: - Handle Completion with Error
    func handleCompletionWithError() {
        viewModel.handleCompletionWithError = {[weak self] error in
            DispatchQueue.main.async {
                CommonClass.shared.showAlertWithTitle(messageBody: error.localizedDescription, okBlock: {
                    self?.updateLoader()
                })
            }
        }
    }
    
    // MARK: - Handle Internet error
    func handleInternetError() {
        viewModel.handleInternetError = {[weak self] in
            DispatchQueue.main.async {
                CommonClass.shared.showAlertWithTitle(messageBody: LocalizedString.NOINTERNETCONNECTION, okBlock: {
                    self?.updateLoader()
                })
            }
        }
    }
    
    // MARK: - Completion Next Page Loading
    func handleNextPageLoading() {
        viewModel.handleNextPageLoading = {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.tableFooterView?.isHidden = false
                self?.tableFooterLoader.startAnimating()
            }
        }
    }
    
    // MARK: - Refresh Table View Data
    @objc func refreshTableViewData() {
        viewModel.refreshData()
    }
    
    // MARK: - Update Loader
    func updateLoader() {
        DispatchQueue.main.async {
            self.tableView.tableFooterView?.isHidden = true
            self.tableFooterLoader.stopAnimating()
            CommonClass.shared.hideLoader()
            self.refreshControl.endRefreshing()
        }
    }
    
    // MARK: - Navigate to Delivery Item Detail Screen
    func navigateToDeliveryItemDetail(withItemDetailVM itemDetailVM: DeliveryDetailViewModel) {
        let itemDetailVC = DeliveryDetailViewController()
        itemDetailVC.itemDetailVM = itemDetailVM
        self.navigationController?.pushViewController(itemDetailVC, animated: true)
    }
}

// MARK: - Extension For Table View Delegate And Datasource Methods
extension DeliveryItemListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.deliveries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellUniqueIdentifier, for: indexPath) as! DeliveryItemCell
        cell.plotDataOnCell(withCellItem : viewModel.deliveries[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.checkBottomDragging(indexPath.row)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = self.viewModel.getDeliveryDetailViewModel(fromIndex: indexPath.row) {
            self.navigateToDeliveryItemDetail(withItemDetailVM: viewModel)
        }
    }
}
