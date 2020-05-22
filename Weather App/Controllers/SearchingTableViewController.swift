//
//  SearchingTableViewController.swift
//  Weather App
//
//  Created by Karrar Abd Ali on 21/05/2020.
//  Copyright © 2020 Karrar Abd Ali. All rights reserved.
//

import UIKit

protocol searchDelegate:AnyObject {
    func didGetWeatherItem(weatherObject: WeatherObject)
}

class SearchingTableViewController: UITableViewController {
    var weatherItems: [WeatherObject] = []
    var searchResult: WeatherObject?
    var searchedArray: [String] = []
    var isSearching: Bool = false
    
    var cities: [String] = ["Bialystok","Bydgoszcz","Gdansk","Gdynia","Katowice","Krakow","Lodz","Lublin","Poznan","Sopot","Szczecin","Torun","Warsaw","Wroclaw","Zakopane"]
    weak var delegate: searchDelegate?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        weatherItems.forEach{ if !cities.contains($0.name) {
            cities.append($0.name)
            }}
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundView = blurEffectView
        tableView.backgroundColor = .clear

        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count =  isSearching ?  searchedArray.count : cities.count
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        if isSearching {
            cell.textLabel?.text = searchedArray[indexPath.row]
        } else {
            cell.textLabel?.text = cities[indexPath.row]
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city: String
        if isSearching {
             city = searchedArray[indexPath.row]
            
        } else {
             city = cities[indexPath.row]
        }
        if !isCitySearchedBefore(city) {
            NetworkServices().fetchWeatherData(city: city, completion: { result in
                switch result{
                case .success(let obj):
                    self.delegate?.didGetWeatherItem(weatherObject: obj)
                case .failure(let error): print(error)
                }
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helper methods
    private func isCitySearchedBefore(_ city: String) -> Bool {
        let a = weatherItems.filter{$0.name == city}
        if (a.count != 0) {
            return true
        }
        return false
    }
    
}
extension SearchingTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let city = searchBar.text {
            if !isCitySearchedBefore(city) {
                NetworkServices().fetchWeatherData(city: city) { (result) in
                    switch result{
                    case.success(let weatherObject):
                        self.delegate?.didGetWeatherItem(weatherObject: weatherObject)
                        self.dismiss(animated: true, completion: nil)
                    case.failure(let error): print(error)
                    }
                }
            }
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        searchedArray = cities.filter({$0.prefix(searchText.count) == searchText})
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
    
}
