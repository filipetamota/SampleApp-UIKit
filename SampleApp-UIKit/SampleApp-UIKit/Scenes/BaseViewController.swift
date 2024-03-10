//
//  BaseViewController.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 21/2/24.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    var spinner: UIActivityIndicatorView?
    var spinnerView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showLoadingIndicator() {
        let spinnerView = UIView(frame: view.bounds)
        spinnerView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        view.isUserInteractionEnabled = false
        spinnerView.addSubview(spinner)
        self.spinner = spinner

        spinner.centerXAnchor.constraint(equalTo: spinnerView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: spinnerView.centerYAnchor).isActive = true
        view.addSubview(spinnerView)
        self.spinnerView = spinnerView
    }

    func hideLoadingIndicator() {
        self.spinner?.stopAnimating()
        view.isUserInteractionEnabled = true
        self.spinnerView?.removeFromSuperview()
    }
}
