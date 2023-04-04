//
//  ViewController.swift
//  SearchBarTableView
//
//  Created by Mac on 04/04/23.
//

import UIKit

class ViewController: UIViewController,UISearchBarDelegate,UISearchControllerDelegate {
    @IBOutlet weak var postTableView: UITableView!
    var posts = [Post]()
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        postTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        jsonParser()
        searchBarSetup()
    }
     private func jsonParser(){
        let urlstring = "https://jsonplaceholder.typicode.com/posts"
        let url = URL(string: urlstring)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest){data,response,error in
            print(String(data: data!, encoding: .utf8)!)
            print(response!)
            let jsonDecoder = JSONDecoder()
            let postResponse = try! jsonDecoder.decode([Post].self, from: data!)
            self.posts = postResponse
            DispatchQueue.main.async {
                self.postTableView.reloadData()
            }
        }.resume()
        
    }
     private func searchBarSetup(){
       searchController.searchResultsUpdater = self
       searchController.searchBar.delegate = self
      navigationItem.searchController = searchController
    }
}
extension ViewController: UISearchResultsUpdating{
func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text else {return}
    if searchText == ""{
        jsonParser()
    }else{
        posts = posts.filter{
            $0.title.contains(searchText.lowercased())
        }
    }
    postTableView.reloadData()
}
}
extension ViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(posts[indexPath.row].id)"
        cell.detailTextLabel?.text = posts[indexPath.row].title
        cell.textLabel?.textAlignment = .init(.center)
        cell.textLabel?.textColor = UIColor.darkText
        cell.textLabel?.font = .boldSystemFont(ofSize: 20)
        cell.detailTextLabel?.textColor = .black
        cell.detailTextLabel?.font = .systemFont(ofSize: 17)
        cell.detailTextLabel?.numberOfLines = 0
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 4
        cell.layer.borderColor = .init(genericCMYKCyan: 2, magenta: 2, yellow: 1, black: 2, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         100
        
    }
}

