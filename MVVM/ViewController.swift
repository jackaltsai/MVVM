//
//  ViewController.swift
//  MVVM
//
//  Created by Zyko on 2023/3/8.
//

import UIKit
import Kingfisher

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let myToken = "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"
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var viewModel = UserListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        viewModel.users.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        fetchData()
    }
    
    // table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.users.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
        let url = URL(string: (viewModel.users.value?[indexPath.row].avatar_url)!)
        let resource = ImageResource(downloadURL: url!)
        let processor = DownsamplingImageProcessor(size: CGSize(width: 40, height: 40))
                        |> RoundCornerImageProcessor(cornerRadius: 20)
        KingfisherManager.shared.retrieveImage(with: resource, options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .loadDiskFileSynchronously,
            .cacheOriginalImage
        ]) { result in
            switch result {
            case .success(let value):
                content.image = value.image
            case .failure(let error):
                print(error.localizedDescription)
                content.image = UIImage(systemName: "star")
            }
        }
        
        
        content.text = viewModel.users.value?[indexPath.row].login
        
        cell.layoutMargins = UIEdgeInsets.zero
        if ((viewModel.users.value?[indexPath.row].site_admin) == true) {
            content.secondaryText = NSLocalizedString("Admin", comment: "")
            content.secondaryTextProperties.color = .red
        } else {
            content.secondaryText = NSLocalizedString("Staff", comment: "")
            content.secondaryTextProperties.color = .blue
        }
         
        cell.contentConfiguration = content
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.username = (viewModel.users.value?[indexPath.row].login)!
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.selectionStyle = .none
        }
    }
    
    func fetchData() {
        
        guard let url = URL(string: "https://api.github.com/users?per_page=65&page=1") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(myToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            
            do {
                let userModels =  try JSONDecoder().decode([User].self, from: data)
                
                self.viewModel.users.value = userModels.compactMap({
                    UserTableViewCellViewModel(avatar_url: $0.avatar_url, login: $0.login, site_admin: $0.site_admin)
                })
            }
            catch {
                print(error)
            }
            
        }
        task.resume()
        
    }
    
}
