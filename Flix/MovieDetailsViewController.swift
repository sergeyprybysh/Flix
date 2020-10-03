//
//  MovieDetailsViewController.swift
//  Flix
//
//  Created by Sergey Prybysh on 9/30/20.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {
    @IBOutlet var backdropView: UIImageView!
    @IBOutlet var posterView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var synopsisLabel: UILabel!
    
    @IBAction func posterTap(_ sender: UITapGestureRecognizer) {
        let viewController = TrailerViewController()
        viewController.movieId = movie.id

        present(viewController, animated: true, completion: nil)
    }

    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie.title
        synopsisLabel.text = movie.overview
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie.posterPath
        let posterUrl = URL(string: baseUrl + posterPath)
        
        posterView.af.setImage(withURL: posterUrl!)
        
        let backdropPath = movie.backdropPath
        let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
        backdropView.af.setImage(withURL: backdropUrl!)
    }
}
