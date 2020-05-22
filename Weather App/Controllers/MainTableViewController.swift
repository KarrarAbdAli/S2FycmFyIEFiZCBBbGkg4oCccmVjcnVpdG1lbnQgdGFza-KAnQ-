//
//  MainTableViewController.swift
//  Weather App
//
//  Created by Karrar Abd Ali on 21/05/2020.
//  Copyright © 2020 Karrar Abd Ali. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    private let identifier = "cellIdentifier"
    var weatherItems: [WeatherObject] = []
    
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var fButton: UIButton!
    
    var status: degreeStatus = .c {
        didSet {
            if status == .c {
                cButton.setTitleColor(.white, for: .normal)
                fButton.setTitleColor(.darkGray, for: .normal)
                tableView.reloadData()
                
            } else {
                fButton.setTitleColor(.white, for: .normal)
                cButton.setTitleColor(.darkGray, for: .normal)
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        // Loding Core Data context
        loadData()
        //Fetching free data to start the app with
        fetchFreeData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? SearchingTableViewController
        vc?.delegate = self
        vc?.weatherItems = self.weatherItems
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weatherItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! WeatherItemCell
        cell.cityLabel.text = weatherItems[indexPath.row].name
        var tempreture: Int = 0
        
        if let main = weatherItems[indexPath.row].main {
            if status == .f {
                tempreture = ConversionService.getTempretureInF(main.temp)
            } else {
                tempreture = ConversionService.getTempretureInC(main.temp)
            }
        }
        cell.degreeLable.text = String((tempreture)) + "°" // kelven to C or F
        if let weather = weatherItems[indexPath.row].weather{
            cell.iconImageView.image = UIImage(named: weather[0].icon)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController(weatherObject: weatherItems[indexPath.row], status: status)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            PersistentStore().delteObject(withid: weatherItems[indexPath.row].id, completion: { result in
                switch result{
                case .success(_):
                    self.weatherItems.remove(at: indexPath.row)
                    self.tableView.reloadData()
                case .failure(let error): print(error)
                }
            })
        }
    }
    
    // MARK: - Helper Methods
    private func setupTableView(){
        tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
        tableView.separatorColor = UIColor.white
        //        tableView.allowsSelection = false
        tableView.register(UINib(nibName: "WeatherItemCell", bundle: .main), forCellReuseIdentifier: identifier)
    }
    
    private func loadData(){
        PersistentStore().loadData { (result) in
            switch result {
            case .success(let weatherObjs):
                self.weatherItems = weatherObjs
                self.tableView.reloadData()
            case .failure(let error): print(error)
            }
        }
    }
    
    private func fetchFreeData(){
        NetworkServices().freeFetchAPICall { result in
            switch result {
            case.success(let object): self.updateOrAddWeatherItem(withId: object.id, weatherItem: object)
            case.failure(let error): print(error)
            }
        }
    }
    
    @IBAction func cDegreeChoosen(_ sender: Any) {
        status = .c
    }
    
    @IBAction func fDegreeChoosen(_ sender: Any) {
        status = .f
    }
    
    private func updateOrAddWeatherItem(withId id: Int, weatherItem: WeatherObject){
        if isItemWithIdExist(id: id) {
            let mapedWeatherItems = weatherItems.map({ $0.id == id ? weatherItem : $0 })
            weatherItems = mapedWeatherItems
        }
    }
    
    private func isItemWithIdExist(id: Int) -> Bool {
        let value = weatherItems.filter({$0.id == id}).count
        if value == 0 {
            return false
        } else {
            return true
        }
    }
    
    
}

extension MainTableViewController: searchDelegate {
    func didGetWeatherItem(weatherObject: WeatherObject) {
        self.weatherItems.append(weatherObject)
        tableView.reloadData()
        PersistentStore().save(weatherObject: weatherObject)
    }
    
}

enum degreeStatus {
    case c
    case f
}

