//
//  ViewController.swift
//  WeatherPal
//
//  Created by Gehad V on 12/10/2024.
//

import UIKit
import RxSwift
import ALLoadingView

class HomeViewController: UIViewController {

    var viewModel: HomeViewModelProtocol?
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var currentWeatherView: CurrentWeatherView!
    @IBOutlet weak var fullWeatherView: UIView!
    
    @IBOutlet weak var fullWeatherTableView: UITableView!
    
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var emptyView: EmptyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = HomeViewModel()
        self.setupUI()
        self.initBinding()
    }
    
    private func setupUI() {
        customizeLoadingView()
        searchTextField.delegate = self
        segmentControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: Constants.selectedTextColor], for: .selected)
        segmentControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        setupTableView()
        self.fullWeatherView.layer.cornerRadius = Constants.cornerRadius
        self.fullWeatherView.layer.masksToBounds = true

    }
    
    private func setupTableView() {
        fullWeatherTableView.delegate = self
        fullWeatherTableView.dataSource = self
        fullWeatherTableView.register(UINib(nibName: "WeatherTableViewCell",
                                            bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
    }
    
    private func customizeLoadingView() {
        ALLoadingView.manager.blurredBackground = true
        ALLoadingView.manager.windowRatio = 0.3
    }
    
    private func initBinding() {
        self.viewModel?.reloadCurrentWeatherSubject.asObservable().subscribe(onNext: {  [weak self] shouldReload in
            ALLoadingView.manager.hideLoadingView(withDelay: 0)
            guard shouldReload != false else {return }
            self?.showCurrentWeatherView(show: true)
        }).disposed(by: disposeBag)
        
        self.viewModel?.reloadCompleteWeatherSubject.asObservable().subscribe(onNext: { [weak self] shouldReload in
            ALLoadingView.manager.hideLoadingView(withDelay: 0)
            guard shouldReload != false else {return }
            self?.showMultipleDataView(show: true)
        }).disposed(by: disposeBag)
        
        
        self.viewModel?.noDataFoundSubject.asObservable().subscribe(onNext: { [weak self] shouldReload in
            ALLoadingView.manager.hideLoadingView(withDelay: 0)
            self?.toggleViewsAppearance(showSegment: false)
        }).disposed(by: disposeBag)
    }
    
    private func toggleViewsAppearance(showSegment: Bool) {
        self.segmentControl.isHidden = !showSegment
        self.emptyView.isHidden = showSegment ? true : false
        self.currentWeatherView.isHidden = true
        self.fullWeatherView.isHidden = true
    }

    
    private func showCurrentWeatherView(show: Bool) {
        guard show != false,
              let location = viewModel?.locationDetails,
              let weatherData = viewModel?.currentWeatherData else {
            currentWeatherView.isHidden = true
            toggleViewsAppearance(showSegment: false)
            return
        }
        currentWeatherView.setup(location: location, data: weatherData)
        currentWeatherView.isHidden = false
        emptyView.isHidden = true
        fullWeatherView.isHidden = true
    }
    
    private func showMultipleDataView(show: Bool) {
        guard show != false,
              viewModel?.multipleDaysForecastData != nil  else {
            fullWeatherView.isHidden = true
            toggleViewsAppearance(showSegment: false)
            return
        }
        self.fullWeatherTableView.reloadData()
        currentWeatherView.isHidden = true
        emptyView.isHidden = true
        fullWeatherView.isHidden = false

    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            showCurrentWeatherView(show: true)
        case 1:
            showMultipleDataView(show: true)
        default:
            break
        }
    }
    
    
}

extension HomeViewController: UITextFieldDelegate {
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchQuery = textField.text, !searchQuery.isEmpty else {toggleViewsAppearance(showSegment: false); return  true }
        textField.resignFirstResponder()
        toggleViewsAppearance(showSegment: true)
        ALLoadingView.manager.showLoadingView(ofType: .basic,windowMode: .windowed)
        self.viewModel?.mode = segmentControl.selectedSegmentIndex == 0 ? .currentWeather : .multipleDaysWeather
        self.viewModel?.getWeatherData(for: searchQuery)
        return true
    }

}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.multipleDaysForecastData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as? WeatherTableViewCell,
              let cellData = self.viewModel?.multipleDaysForecastData?[indexPath.row] else {return UITableViewCell()}
        cell.setup(data: cellData)
        return cell
    }
    
    
    
}
