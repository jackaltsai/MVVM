//
//  DetailViewController.swift
//  MVVM
//
//  Created by Zyko on 2023/3/8.
//

import UIKit
import Kingfisher
import MBProgressHUD

class DetailViewController: UIViewController {
    
    let myToken = "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"
    var username: String = ""

    private var viewModel = UserDetailViewModel()

    private lazy var imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bio: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    lazy var userImageView: UIImageView = {
        let image = UIImage(systemName: "person.fill")
        let imageview = UIImageView(image: image)
        imageview.tintColor = .black
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var locationImageView: UIImageView = {
        let image = UIImage(systemName: "location.fill")
        let imageview = UIImageView(image: image)
        imageview.tintColor = .black
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var linkImageView: UIImageView = {
        let image = UIImage(systemName: "link.circle.fill")
        let imageview = UIImageView(image: image)
        imageview.tintColor = .black
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var linkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var roleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        button.backgroundColor = .blue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Loading"
        hud.contentColor = UIColor.white
        hud.bezelView.color = UIColor.black
        hud.mode = .indeterminate

        fetchData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            hud.hide(animated: true)
        }
        setupUI()
        saveButton.addTarget(self, action: #selector(saveMethod(sender:)), for: .touchUpInside)
    }
    
    func setupUI() {
        view.addSubview(imageView)
        view.addSubview(name)
        view.addSubview(bio)
        view.addSubview(userImageView)
        view.addSubview(locationImageView)
        view.addSubview(linkImageView)
        view.addSubview(loginLabel)
        view.addSubview(locationLabel)
        view.addSubview(linkLabel)
        view.addSubview(roleLabel)
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            name.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            name.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            bio.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bio.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            bio.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            bio.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: bio.bottomAnchor, constant: 50),
            userImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            userImageView.widthAnchor.constraint(equalToConstant: 50),
            userImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: bio.bottomAnchor, constant: 50),
            loginLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            roleLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 5),
            roleLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            roleLabel.widthAnchor.constraint(equalToConstant: 55)
        ])
        
        NSLayoutConstraint.activate([
            locationImageView.topAnchor.constraint(equalTo: bio.bottomAnchor, constant: 120),
            locationImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            locationImageView.widthAnchor.constraint(equalToConstant: 50),
            locationImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: bio.bottomAnchor, constant: 135),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            linkImageView.topAnchor.constraint(equalTo: bio.bottomAnchor, constant: 190),
            linkImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            linkImageView.widthAnchor.constraint(equalToConstant: 50),
            linkImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            linkLabel.topAnchor.constraint(equalTo: bio.bottomAnchor, constant: 205),
            linkLabel.leadingAnchor.constraint(equalTo: linkImageView.trailingAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: linkLabel.bottomAnchor, constant: 50),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func fetchData() {
        
        guard let url = URL(string: "https://api.github.com/users/\(username)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(myToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            
            do {
                let userModel =  try JSONDecoder().decode(UserDetail.self, from: data)
                let url = URL(string: userModel.avatar_url)!
                let resource = ImageResource(downloadURL: url)
                let processor = DownsamplingImageProcessor(size: CGSize(width: 300, height: 300))
                                |> RoundCornerImageProcessor(cornerRadius: 150)
//                print(userModel)
                DispatchQueue.main.async {
                    self.name.text = userModel.name
                    
                    KingfisherManager.shared.retrieveImage(with: resource, options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .loadDiskFileSynchronously,
                        .cacheOriginalImage
                    ]) { result in
                        switch result {
                        case .success(let value):
                            self.imageView.image = value.image
                        case .failure(let error):
                            print(error.localizedDescription)
                            self.imageView.image = UIImage(systemName: "star")
                        }
                    }
                    
                    self.bio.text = userModel.bio
                    self.loginLabel.text = userModel.login
                    self.locationLabel.text = userModel.location
                    let urlString = userModel.blog
                    let attributedString = NSAttributedString(string: urlString ?? "", attributes: [.link: URL(string: urlString ?? "") ?? ""])
                    self.linkLabel.attributedText = attributedString
                    if userModel.site_admin == true {
                        self.roleLabel.text = NSLocalizedString("ADMIN", comment: "")
                        self.roleLabel.backgroundColor = .red
                    } else {
                        self.roleLabel.text = NSLocalizedString("STAFF", comment: "")
                        self.roleLabel.backgroundColor = .blue
                    }
                }
                
            }
            catch {
                print(error)
            }
            
        }
        task.resume()
        
    }
    
    
    @objc func saveMethod(sender: UIButton) {
        let alertController = UIAlertController(title: NSLocalizedString("System Message", comment: ""), message: NSLocalizedString("Not yet to save, just say finsh!", comment: ""), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
