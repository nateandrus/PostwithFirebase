//
//  PostsViewController.swift
//  PostProject
//
//  Created by Nathan Andrus on 2/6/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var posts: [Post] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
        self.refreshPage()
    }
   
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        refreshPage()
    }
    
    func refreshPage() {
        PostController.shared.fetchPosts { (posts) in
            self.posts = posts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        let post = posts[indexPath.row]
        cell.nameLabel.text = post.name
        cell.cohortLabel.text = post.cohort
        cell.reasonLabel.text = post.reason
        return cell
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        newPostAlertController()
    }
    
    func newPostAlertController() {
        var nameTextField: UITextField?
        var cohortTextField: UITextField?
        var reasonTextField: UITextField?
        
        let newPostController = UIAlertController(title: "New Post", message: "Why iOS?", preferredStyle: .alert)
        newPostController.addTextField { (textField) in
            textField.placeholder = "Name..."
            nameTextField = textField
        }
        newPostController.addTextField { (textField) in
            textField.placeholder = "Which cohort are you in?"
            cohortTextField = textField
        }
        newPostController.addTextField { (textField) in
            textField.placeholder = "Why did you want to learn iOS?"
            reasonTextField = textField
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let postAction = UIAlertAction(title: "Add Post", style: .default) { (_) in
            guard let nameText = nameTextField?.text, !nameText.isEmpty,
                let cohortText = cohortTextField?.text, !cohortText.isEmpty,
                let reasonText = reasonTextField?.text, !reasonText.isEmpty else { return }
            PostController.shared.postReason(cohort: cohortText, name: nameText, reason: reasonText, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.refreshPage()
                    }
                }
            })
        }
        newPostController.addAction(cancelAction)
        newPostController.addAction(postAction)
        
        self.present(newPostController, animated: true, completion: nil)
    }
}
