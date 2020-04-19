//
//  DataCoordinatorTests.swift
//  Celo testTests
//
//  Created by Raj Patel on 19/04/20.
//  Copyright © 2020 Raj Patel. All rights reserved.
//

import XCTest
import CoreData
import UIKit
@testable import Celo_test

class DataCoordinatorTests: XCTestCase {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var fetchedResultsController: NSFetchedResultsController<Person>? = {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "streetNum", ascending:true)]
        
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
    
    override func setUpWithError() throws {
        guard let container = appDelegate?.persistentContainer else { return }
        let dataCoord = DataCoordinator(container: container)
        let testData = generateTestData()
        dataCoord.saveResults(testData, context: container.newBackgroundContext())
    }
    
    private func generateTestData() -> [User] {
        var people: [User] = []
        for i in 1...50 {
            let user = User(gender: "male",
                            cell: "",
                            email: "person@\(i).com",
                            name: Name(first: "Person", last: "\(i)", title: ""),
                            picture: Picture(large: "", medium: "", thumbnail: ""),
                            location: Location(city: "Auckland", country: "NZ", state: "", street: Street(name: "", number: i), timezone: Timezone(description: "", offset: "")),
                            dob: DOB(date: "", age: i))
            people.append(user)
        }
        return people
    }

    override func tearDownWithError() throws {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try appDelegate?.persistentContainer.viewContext.execute(deleteRequest)
    }

    func testNumberOfObjectsInFetchController() throws {
        XCTAssertTrue(fetchedResultsController?.sections?.count == 1)
        XCTAssertTrue(fetchedResultsController?.sections?[0].numberOfObjects == 50, "It should be 50 not \(fetchedResultsController?.sections?[0].numberOfObjects ?? 0)")
    }
    
    func testObjectAtIndexPath() {
        let indexPath = IndexPath(row: 24, section: 0)
        let person = fetchedResultsController?.object(at: indexPath)
        XCTAssertTrue(person?.name == "Person 25", "It should be Person 5 not \(person?.name ?? "")")
    }
}
