//
//  ViewController.swift
//  NewsApp
//
//  Created by Bauyrzhan Abdi on 05.02.2023.
//

import UIKit

final class NewsViewController: UIViewController {

    private lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)

        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    private var model = [NewsModel]()
    private var views = [Views]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.backgroundColor = .systemBackground
        loadData()
        setup()
    }
    
    
    private func setup() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadData() {
        NetworkService.shared.getContent { [weak self] result in
            switch result {
            case .success(let articles):
                let shuffled = articles.shuffled()
                let pagination20 = Array(shuffled.prefix(20))
                self?.model = pagination20.compactMap { article in
                    NewsModel(
                        title: article.title,
                        publisher: article.source.name,
                        description: article.description ?? "No description has been provided",
                        websiteUrl: article.websiteUrl ?? "",
                        date: self?.formatDate(dateString: article.date) ?? "Date is unknown",
                        imageUrl: URL(string: article.imageUrl ?? ""))
                }
                if let len = self?.model.count {
                    self?.views = [Views](repeating: Views(counter: 0), count: len)
                }
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func formatDate(dateString: String?) -> String {
        guard let dateString = dateString else { return "Date is unknown" }
        if let date = ISO8601DateFormatter().date(from: dateString) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            let result = dateFormatter.string(from: date)
            return result
        }
        return "Date is unknown"
    }
    
    @objc private func refreshData() {
        print("Refreshed")
        loadData()
        refreshControl.endRefreshing()
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell
        else { fatalError("cell is null") }
        cell.configure(with: model[indexPath.row])
        cell.view.backgroundColor = UIColor.cellColor[indexPath.row % 2]
        cell.count.text = "View count: \(views[indexPath.row].counter)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        views[indexPath.row].counter += 1
        tableView.reloadData()
        let nextController = DetailViewController(model: model[indexPath.row])
        navigationController?.pushViewController(nextController, animated: true)
    }
}


struct Views {
    var counter: Int = 0
}
