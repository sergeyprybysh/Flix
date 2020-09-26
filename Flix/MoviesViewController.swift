//
//  MoviesViewController.swift
//  Flix
//
//  Created by Sergey Prybysh on 9/24/20.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
    }
    
    func fetchData() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    
                    let moviesResult = try decoder.decode(MoviesResult.self, from: data)
                    self.movies = moviesResult.results
                    self.tableView.reloadData()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        let movie = movies[indexPath.row]
        let title = movie.title
        let synopsis = movie.overview
        let posterPath = movie.posterPath
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        return cell
    }
}

