//
//  TrailerViewController.swift
//  Flix
//
//  Created by Sergey Prybysh on 10/1/20.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController, WKUIDelegate {
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)

    var webView: WKWebView!
    var movieId: Int!
    var trailerKey: String?

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray

        fetchTrailer()
    }
    
    func fetchTrailer() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId!)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")!

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)

        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                do {
                    let trailerResult = try JSONDecoder().decode(TrailerResult.self, from: data)

                    self.trailerKey = trailerResult.results[0].key
                    if let key = self.trailerKey {
                        self.displayTrailer(for: key)
                    } else {
                        self.presentNoTrailerAlert()
                    }
                } catch let error {
                    self.presentNoTrailerAlert()
                    print(error.localizedDescription)
                }
            }
        }

        task.resume()
    }

    func displayTrailer(for key: String) {
        let trailerUrl = URL(string: "https://www.youtube.com/watch?v=\(key)")!
        let trailerRequest = URLRequest(url: trailerUrl)
        webView.load(trailerRequest)
    }
    
    func presentNoTrailerAlert() {
        let alert = UIAlertController(title: "No trailer", message: "Trailer is not found for the selected movie. Please try another movie", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
