// Блок 1

import Foundation

struct City: Codable {
    let name: String
    let timezone: String
    let currency: String
    let coords: Coords?
    
    struct Coords: Codable {
        let latitude: Double?
        let longitude: Double?
    }
}

### CityTableViewCell.swift (Ячейка таблицы):

class CityTableViewCell: UITableViewCell {
    
    private let colorCircleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timezoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(colorCircleView)
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(timezoneLabel)
        contentView.addSubview(currencyLabel)
        
        NSLayoutConstraint.activate([
            colorCircleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorCircleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorCircleView.widthAnchor.constraint(equalToConstant: 20),
            colorCircleView.heightAnchor.constraint(equalToConstant: 20),
            
            cityNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cityNameLabel.leadingAnchor.constraint(equalTo: colorCircleView.trailingAnchor, constant: 16),
            
            timezoneLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 4),
            timezoneLabel.leadingAnchor.constraint(equalTo: colorCircleView.trailingAnchor, constant: 16),
            
            currencyLabel.topAnchor.constraint(equalTo: timezoneLabel.bottomAnchor, constant: 4),
            currencyLabel.leadingAnchor.constraint(equalTo: colorCircleView.trailingAnchor, constant: 16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with city: City) {
        cityNameLabel.text = city.name
        timezoneLabel.text = "Timezone: \(city.timezone)"
        currencyLabel.text = "Currency: \(city.currency)"
        
        let circleColor: UIColor
        if let latitude = city.coords?.latitude, let longitude = city.coords?.longitude {
            if latitude + longitude < 100 {
                circleColor = UIColor(red: 153/255, green: 204/255, blue: 1, alpha: 1) // Светло-голубой цвет
            } else {
                circleColor = UIColor(red: 153/255, green: 102/255, blue: 1, alpha: 1) // Фиолетовый цвет
            }
        } else {
            circleColor = UIColor.lightGray
        }
        colorCircleView.backgroundColor = circleColor
    }
}

### CitiesTableViewController.swift (TableViewController для отображения городов):

class CitiesTableViewController: UITableViewController {
    
    private var cities: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: "CityCell")
        
        fetchData()
    }
}

// Блок 2

import UIKit
import PlaygroundSupport

DispatchQueue.main.async {
    print("H")
    sleep(1)
    print("E")
    print("L")
    print("L")
    print("O")
}

DispatchQueue.global().async {
    print("H")
    sleep(1)
    print("E")
    print("L")
    print("L")
    print("O")
}

DispatchQueue.global().async {
    print("H")
    sleep(1)
    DispatchQueue.main.async {
        print("E")
        print("L")
        print("L")
        print("O")
    }
}

DispatchQueue.global().async {
    print("H")
    sleep(1)
    DispatchQueue.main.sync {
        print("E")
        print("L")
        print("L")
        print("O")
    }
}

// Д.З. Исправленная 3 семинара

import Foundation
import UIKit

class NetworkService {
    
    func getFriendsList(token: String) {
        let friendsURL = URL(string: "https://api.vk.com/method/friends.get?access_token=\(token)&v=5.131")!
        URLSession.shared.dataTask(with: friendsURL) { data, response, error in
            if let data = data {
                do {
                    let friendsResponse = try JSONDecoder().decode(FriendsResponse.self, from: data)
                    print("Friends List:")
                    print(friendsResponse)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
    
    func getGroupsList(token: String) {
        let groupsURL = URL(string: "https://api.vk.com/method/groups.get?access_token=\(token)&v=5.131")!
        URLSession.shared.dataTask(with: groupsURL) { data, response, error in
            if let data = data {
                do {
                    let groupsResponse = try JSONDecoder().decode(GroupsResponse.self, from: data)
                    print("Groups List:")
                    print(groupsResponse)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
    
    func getPhotosList(token: String) {
        let photosURL = URL(string: "https://api.vk.com/method/photos.getAll?access_token=\(token)&v=5.131")!
        URLSession.shared.dataTask(with: photosURL) { data, response, error in
            if let data = data {
                do {
                    let photosResponse = try JSONDecoder().decode(PhotosResponse.self, from: data)
                    print("Photos List:")
                    print(photosResponse)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
}

struct FriendsResponse: Codable {
    // Структура модели для списка друзей
}

struct GroupsResponse: Codable {
    // Структура модели для списка групп
}

struct PhotosResponse: Codable {
    // Структура модели для списка фото
}

class FriendsViewController: UIViewController {
    
    private let token: String
    private let networkService = NetworkService()
    
    init(token: String) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.getFriendsList(token: token)
    }
}

class GroupsViewController: UIViewController {
    
    private let token: String
    private let networkService = NetworkService()
    
    init(token: String) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.getGroupsList(token: token)
    }
}

class PhotosViewController: UIViewController {
    
    private let token: String
    private let networkService = NetworkService()
    
    init(token: String) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.getPhotosList(token: token)
    }
}

// Д.З. 4 семинар

### FriendsViewController.swift:

import UIKit

class FriendsViewController: UIViewController {
    
    private let token: String
    private let networkService = NetworkService()
    
    private var friends: [Friend] = []
    
    private let tableView = UITableView()
    
    init(token: String) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        getFriendsList()
    }
    
    func getFriendsList() {
        networkService.getFriendsList(token: token) { [weak self] result in
            switch result {
            case .success(let friends):
                self?.friends = friends
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error getting friends: \(error)")
            }
        }
    }
    
    func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
}

extension FriendsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
        let friend = friends[indexPath.row]
        cell.textLabel?.text = friend.name
        cell.detailTextLabel?.text = friend.isOnline ? "Online" : "Offline"
        return cell
    }
}

### Models:

struct Friend: Codable {
    let id: Int
    let name: String
    let isOnline: Bool
}

struct FriendsResponse: Codable {
    let response: [Friend]
}

### NetworkService.swift:

import Foundation

class NetworkService {
    
    func getFriendsList(token: String, completion: @escaping (Result<[Friend], Error>) -> Void) {
        let friendsURL = URL(string: "https://api.vk.com/method/friends.get?access_token=\(token)&v=5.131")!
        URLSession.shared.dataTask(with: friendsURL) { data, response, error in
            if let data = data {
                do {
                    let friendsResponse = try JSONDecoder().decode(FriendsResponse.self, from: data)
                    completion(.success(friendsResponse.response))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}