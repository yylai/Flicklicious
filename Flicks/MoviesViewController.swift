//
//  MoviesViewController.swift
//  Flicks
//
//  Created by YINYEE LAI on 10/14/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var movies: [NSDictionary]?
    var filteredMovies:[NSDictionary]?
    var isSearching: Bool = false
    var endPoint: String = "now_playing"
    let rootUrl: String = "https://api.themoviedb.org/3/movie/"
    let apiKey: String = "a07e22bc18f5cb106bfe4cc1f83ad8ed"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshControlAction(refreshControl:)), for: .valueChanged)
        movieTableView.insertSubview(refreshControl, at: 0)
        
        searchBar.placeholder = "Search movie title.."
        searchBar.delegate = self
        
        errorView.isHidden = true
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        
        
        
        let movieURL = "\(rootUrl)\(endPoint)?api_key=\(apiKey)"
        
        fetchMovies(from: movieURL, refresher: nil, successCallback: self.reloadMovies, errorCallback: self.handleNetworkError)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (isSearching) {
            if let filtered = filteredMovies {
                return filtered.count
            } else {
            return 0
            }
        }
        
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieViewCell
        
        var movie: NSDictionary?
        if isSearching {
            movie = filteredMovies![indexPath.row]
        } else {
            movie = movies![indexPath.row]
        }
        
        let title = movie!["title"] as! String
        let overview = movie!["overview"] as! String
        
        
        cell.titleLabel.text = title
        cell.overViewLabel.text = overview
        
        
        if let posterURL = movie!["poster_path"] as? String {
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let imageURL = URL(string: baseURL + posterURL)
            let imageRequest = URLRequest(url: imageURL!)
            
            cell.posterImageView.setImageWith(imageRequest, placeholderImage: nil, success: { (req, resp, img) in
                if let response = resp {
                        cell.posterImageView.alpha = 0
                        cell.posterImageView.image = img
                    UIView.animate(withDuration: 0.7, animations: {
                        cell.posterImageView.alpha = 1.0
                    })
                    
                } else {
                    cell.posterImageView.image = img
                }
                }, failure: { (req, resp, err) in
                        cell.posterImageView.image = nil
            })
            
            
        } else {
            //set blank image?
        }
        
        
        return cell
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        let movieURL = "\(rootUrl)\(endPoint)?api_key=\(apiKey)"
        
        fetchMovies(from: movieURL, refresher: refreshControl, successCallback: self.reloadMovies, errorCallback: self.handleNetworkError)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = movieTableView.indexPath(for: cell)
        
        var movie: NSDictionary?
        if isSearching {
            movie = filteredMovies![indexPath!.row]
        } else {
            movie = movies![indexPath!.row]
        }
        
        let detailViewController = segue.destination as! DetailViewController
        
        detailViewController.movie = movie
        
    }
    
    func reloadMovies(with movies: [NSDictionary]) {
        self.movies = movies
        self.movieTableView.reloadData()
    }
    
    func handleNetworkError(error: Error) {
        errorView.isHidden = false
        
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            filteredMovies = movies!
        } else {
            filteredMovies = movies!.filter({ (movie) -> Bool in
                let currentTitle = movie["title"] as! String
                let range = currentTitle.range(of: searchText, options: .caseInsensitive)
                return range != nil
            })
        }
        
        self.movieTableView.reloadData()
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        isSearching = false
        // Remove focus from the search bar.
        searchBar.endEditing(true)
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.movieTableView.reloadData()
    }
    
    
    func fetchMovies(from url: String, refresher: UIRefreshControl?, successCallback: ([NSDictionary]) -> Void, errorCallback: ((Error) -> Void)?) {
        
        let movieURL = URL(string: url)
        let request = URLRequest(url: movieURL!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, errorOrNil) in
            if let requestError = errorOrNil {
                errorCallback?(requestError)
                
            } else {
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    //NSLog("response: \(responseDictionary)")
                    let movies = responseDictionary["results"] as! [NSDictionary]
                    self.reloadMovies(with: movies)
                    self.errorView.isHidden = true
                }
            }
            }
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if let refresh = refresher {
                refresh.endRefreshing()
            }
        });
        
        task.resume()
    }
}

