//
//  ViewController.swift
//  Celo test
//
//  Created by Raj Patel on 16/04/20.
//  Copyright © 2020 Raj Patel. All rights reserved.
//

import UIKit
import CoreData

class PeopleViewController: UITableViewController {
    //Ideally, would like to move the coredata stack away from the app delegate to simplify the delegate.
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    lazy var fetchedResultsController: NSFetchedResultsController<Person>? = {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending:true)]
        
        guard let context = appDelegate?.persistentContainer.viewContext else { return nil }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return controller
    }()
    
    //Responsible for pull down to refresh the data
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(downloadData), for: .valueChanged)
        return refreshControl
    }()
    
    lazy var dataCoordinator: DataCoordinator? = {
        guard let container = appDelegate?.persistentContainer else { return nil }
        let dataCoord = DataCoordinator(container: container)
        dataCoord.delegate = self
        return dataCoord
    }()
    
    private let imageCache = NSCache<NSString, UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "People"
        tableView.register(UINib(nibName: String(describing: PeopleCellTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: PeopleCellTableViewCell.self))
        tableView.refreshControl = refresher
        setupSearchController(with: appDelegate?.persistentContainer)
        downloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PeopleCellTableViewCell.self), for: indexPath) as! PeopleCellTableViewCell
        let person = fetchedResultsController?.object(at: indexPath)
        cell.name = (person?.title ?? "") + " " + (person?.name ?? "" )
        cell.gender = person?.gender?.capitalized
        if let birthDate = Date.convertToPrettyString(from: person?.dob ?? "") {
            cell.dob =  "D.O.B: \(birthDate)"
        }
        if let url = person?.thumbnail,
            let image = imageCache.object(forKey: url.absoluteString as NSString) {
            cell.personImage = image
        } else {
        //Lazy loading for images to achieve smooth scroll for the tableview and saving the image to a local cache so we dont have to repeat the network request
            DispatchQueue.global(qos: .background).async {
                if let thumbnailUrl = person?.thumbnail,
                    let data =  try? Data(contentsOf: thumbnailUrl),
                    let image = UIImage(data:data) {
                        DispatchQueue.main.async {
                            self.imageCache.setObject(image, forKey: thumbnailUrl.absoluteString as NSString)
                            cell.personImage = image
                        }
                } else {
                    DispatchQueue.main.async {
                        cell.personImage = #imageLiteral(resourceName: "placeholder.png")
                    }
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let person = fetchedResultsController?.object(at: indexPath) {
            let controller = PersonViewController(person: person)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc private func downloadData() {
        dataCoordinator?.getPeople {[weak self] error  in
            DispatchQueue.main.async {
                self?.refreshControl?.endRefreshing()
            }
            if error != nil {
                print(error.debugDescription)
            }
        }
    }
    
    private func setupSearchController(with container: NSPersistentContainer?) {
        let resultsController = PeopleSearchResultsViewController()
        resultsController.navController = self.navigationController
        resultsController.container = container
        let searchController = UISearchController(searchResultsController: resultsController)
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Search people"
        searchController.searchResultsUpdater = resultsController
        self.navigationItem.searchController = searchController
    }
}

extension PeopleViewController: DataCoordinatorDelegate {
    func newDataSaved() {
        //This delegate is triggered by the coordinator when theres new data available.
        DispatchQueue.main.async {
            do {
                self.tableView.isUserInteractionEnabled = false
                try self.fetchedResultsController?.performFetch()
                self.tableView.reloadData()
                self.tableView.isUserInteractionEnabled = true
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
