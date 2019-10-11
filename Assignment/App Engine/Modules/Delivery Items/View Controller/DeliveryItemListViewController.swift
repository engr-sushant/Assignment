import UIKit

class DeliveryItemListViewController: UIViewController {

    //MARK:- Constants
    let estimatedRowHeight: CGFloat = 100
    let cellUniqueIdentifier = "Cell"

    //MARK:- Variables
    var tableView = UITableView()
    var refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        return refControl
    }()

    var tableFooterLoader : UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.gray)
        return loader
    }()
    
    var viewModelObject = DeliveryItemViewModel()

    //MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupTableView()
        self.layoutTableView()
        self.setupCompletionHandlers()
        self.viewModelObject.loadDataOnTableView()
    }
    
    //MARK:- Setup Navigation Bar
    func setupNavigationBar() {
        self.title = LocalizedString.ALLITEMVCTITLE
    }
    
    //MARK:- Setup Table View
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DeliveryItemTableViewCell.self, forCellReuseIdentifier: cellUniqueIdentifier)
        tableView.separatorStyle = .none
        tableView.tableFooterView = tableFooterLoader
        refreshControl.addTarget(self, action: #selector(self.refreshTableViewData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    //MARK:- Add Constraints to TableView
    func layoutTableView() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
        
        //Adding constraint to Map View
        let cornerAnchorForTableView = ConrnerAnchor(top    : (self.topLayoutGuide.bottomAnchor, zeroPaddingConstant),
                                                   bottom   : (self.bottomLayoutGuide.topAnchor, zeroPaddingConstant),
                                                   left     : (self.view.leftAnchor, zeroPaddingConstant),
                                                   right    : (self.view.rightAnchor, zeroPaddingConstant)
        )
        tableView.addConstraints(cornerConstraints: cornerAnchorForTableView,
                               centerY  : nil,
                               centerX  : nil,
                               height   : zeroPaddingConstant,
                               width    : zeroPaddingConstant
        )
    }
    
    //MARK: - Setup Completion Handlers
    func setupCompletionHandlers() {
        self.completionWithSuccess()
        self.completionWithNoData()
        self.completionWithError()
        self.failureWithoutError()
        self.handleInternetError()
        self.handleNextPageLoading()
    }
    
    //MARK: - Completion With Success
    func completionWithSuccess() {
        viewModelObject.completionWithSuccess = {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
                self?.updateLoader()
            }
        }
    }
    
    //MARK: - Completion With No Data
    func completionWithNoData() {
        viewModelObject.completionWithNoData = {[weak self] in
            DispatchQueue.main.async {
                CommonClass.shared.showAlertWithTitle(messageBody: LocalizedString.NORESULTFOUND, showRetry: false, okBlock: {
                    self?.updateLoader()
                }, retryBlock: {
                    //
                })
            }
        }
    }
    
    //MARK:- Completion with Error
    func completionWithError() {
        viewModelObject.completionWithError = {[weak self] error in
            DispatchQueue.main.async {
                CommonClass.shared.showAlertWithTitle(messageBody: error.localizedDescription, showRetry: true, okBlock: {
                    self?.updateLoader()
                }, retryBlock: {
                    self?.refreshTableViewData()
                })
            }
        }
    }
    
    //MARK:- Completion with Error
    func failureWithoutError() {
        viewModelObject.failureWithoutError = {[weak self] in
            DispatchQueue.main.async {
                CommonClass.shared.showAlertWithTitle(messageBody: LocalizedString.SERVERERROR, showRetry: false, okBlock: {
                    self?.updateLoader()
                }, retryBlock: {
                    //
                })
            }
        }
    }
    
    //MARK: - Completion Internet error
    func handleInternetError() {
        viewModelObject.handleInternetError = {[weak self] in
            DispatchQueue.main.async {
                CommonClass.shared.showAlertWithTitle(messageBody: LocalizedString.NOINTERNETCONNECTION, showRetry: true, okBlock: {
                    self?.updateLoader()
                }, retryBlock: {
                    self?.refreshTableViewData()
                })
            }
        }
    }
    
    //MARK: - Completion Next Page Loading 
    func handleNextPageLoading() {
        viewModelObject.handleNextPageLoading = {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.tableFooterView?.isHidden = false
                self?.tableFooterLoader.startAnimating()
            }
        }
    }
    
    //MARK:- Refresh Table View Data
    @objc func refreshTableViewData() {
        viewModelObject.refreshTableViewData()
    }
    
    //MARK:- Hide Loader
    func updateLoader() {
        DispatchQueue.main.async {
            self.tableView.tableFooterView?.isHidden = true
            self.tableFooterLoader.stopAnimating()
            CommonClass.shared.hideLoader()
            self.refreshControl.endRefreshing()
        }
    }
    
    //MARK:- Navigate to Item Detail Screen
    func navigateToItemDetail(withItemDetailVM itemDetailVM: DeliveryDetailViewModel) {
        let itemDetailVC = DeliveryDetailViewController()
        itemDetailVC.itemDetailVM = itemDetailVM
        self.navigationController?.pushViewController(itemDetailVC, animated: true)
    }
}

//MARK:- Extension Table View Delegate And Datasource Methods
extension DeliveryItemListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelObject.allItemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellUniqueIdentifier, for: indexPath) as! DeliveryItemTableViewCell
        cell.plotDataOnCell(withCellItem : viewModelObject.allItemArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModelObject.checkTableViewBottomDrag(indexPath.row)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = self.viewModelObject.getItemDetailViewModel(fromIndex: indexPath.row) {
            self.navigateToItemDetail(withItemDetailVM: viewModel)
        }
    }
}
