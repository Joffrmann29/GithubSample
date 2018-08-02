//
//  ViewController.swift
//  GIthubSample
//
//  Created by Joffrey Mann on 8/2/18.
//  Copyright © 2018 Joffrey Mann. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    var githubRepos = [GithubModel]()
    let githubService = GithubService()
    var numResults = 10
    var inset: CGFloat = 0
    var minimumLineSpacing: CGFloat = 0
    var minimumInteritemSpacing: CGFloat = 0
    var cellsPerRow = 1
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var userField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userField.text = "apple"
        self.userField.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.loadGithubRepos()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.loadGithubRepos()
        
        return true
    }
    
    func loadGithubRepos(){
        let results = String(format: "%i", self.numResults)
        self.githubService.fetchReposWithURLSession(user: self.userField.text!, results: results) { (repos) in
            self.githubRepos = repos!
            self.collectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.githubRepos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let githubCell = collectionView.dequeueReusableCell(withReuseIdentifier: "githubCell", for: indexPath) as! GithubCell
        let githubModel = self.githubRepos[indexPath.row]
        
        githubCell.nameLabel.text = githubModel.name
        githubCell.descLabel.text = githubModel.desc
        githubCell.createdLabel.text = githubModel.createdAt
        githubCell.licenseLabel.text = githubModel.license
        
        return githubCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.githubRepos.count - 1 {
            self.numResults = self.numResults + 10
            self.loadGithubRepos()
        }
    }
    
    @IBAction func segmentSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Show List")
            collectionView?.collectionViewLayout.invalidateLayout()
            self.inset = 0
            self.minimumLineSpacing = 0
            self.minimumInteritemSpacing = 0
            self.cellsPerRow = 1
            collectionView.reloadData()
        default:
            print("Show grid")
            collectionView?.collectionViewLayout.invalidateLayout()
            self.inset = 10
            self.minimumLineSpacing = 10
            self.minimumInteritemSpacing = 10
            self.cellsPerRow = 2
            collectionView.reloadData()
        }
    }
}

