//
//  MovieGridViewController.swift
//  Flix
//
//  Created by Sergey Prybysh on 10/1/20.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)

    var movies = [Movie]()

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self

        fetchData()
    }
    
    func fetchData() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)

        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    
                    let moviesResult = try decoder.decode(MoviesResult.self, from: data)
                    self.movies = moviesResult.results
                    self.collectionView.reloadData()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }

        task.resume()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell

        let movie = movies[indexPath.item]
        let posterPath = movie.posterPath
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterUrl = URL(string: baseUrl + posterPath)
        cell.posterView.af.setImage(withURL: posterUrl!)
        return cell
    }
}
