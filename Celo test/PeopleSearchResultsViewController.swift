//
//  PeopleSearchResultsViewController.swift
//  Celo test
//
//  Created by Raj Patel on 18/04/20.
//  Copyright © 2020 Raj Patel. All rights reserved.
//

import UIKit
import CoreData

class PeopleSearchResultsViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate {
    
    var container: NSPersistentContainer?
    var navController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: String(describing: PeopleCellTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: PeopleCellTableViewCell.self))
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchQuery = searchController.searchBar.text
        let searchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        searchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending:true)]
        searchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchQuery ?? "")
        searchRequest.resultType = .managedObjectResultType
        
        do {
            searchResults = try container?.viewContext.fetch(searchRequest)
            self.tableView.reloadData()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PeopleCellTableViewCell.self), for: indexPath) as! PeopleCellTableViewCell
        if searchResults?.count ?? 0 > 0,
            let person = searchResults?[indexPath.row] {
            cell.name = (person.title ?? "") + " " + (person.name ?? "" )
            cell.gender = person.gender?.capitalized
            if let birthDate = Date.convertToPrettyString(from: person.dob ?? "") {
                cell.dob =  "D.O.B: \(birthDate)"
            }
            //enter comment
                DispatchQueue.global(qos: .background).async {
                    if let thumbnailUrl = person.thumbnail,
                        let data =  try? Data(contentsOf: thumbnailUrl),
                        let image = UIImage(data:data) {
                            DispatchQueue.main.async {
                                cell.personImage = image
                            }
                    }
                }
            return cell
        } else {
            return PeopleCellTableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchResults?.count ?? 0 > 0,
        let person = searchResults?[indexPath.row] {
            let controller = PersonViewController(person: person)
            self.navController?.pushViewController(controller, animated: true)
        }
    }
    
    private var searchResults: [Person]? = []
}
