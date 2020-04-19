//
//  DataCoordinator.swift
//  Celo test
//
//  Created by Raj Patel on 16/04/20.
//  Copyright © 2020 Raj Patel. All rights reserved.
//

import Foundation
import CoreData

protocol DataCoordinatorDelegate: class {
    func newDataSaved()
}

class DataCoordinator {
    //This class is responsible for fetching the data from the network and hydrating coredata. :)
    
    weak var delegate: DataCoordinatorDelegate?
    
    //Modify this to change the result size
    let resultSize = 1000
    
    init(container: NSPersistentContainer) {
        self.container = container
        self.service = Service.shared
    }
    
    private let container: NSPersistentContainer
    private let service: Service
    
    func getPeople(completion: @escaping(Error?) -> Void) {
        service.getUsers(with: resultSize) { users, error in
            if let error = error {
                completion(error)
                return
            }
            
            let taskContext = self.container.newBackgroundContext()
            taskContext.undoManager = nil
            
            //save data in to the persistent store
            self.saveResults(users, context: taskContext)
            completion(nil)
        }
    }
    
    func saveResults(_ users: [User]?, context: NSManagedObjectContext?) {
        guard let context = context else { return }
        
        context.performAndWait {
            if users?.count ?? 0 > 0 {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
                do {
                    try context.execute(deleteRequest)
                } catch let error {
                    print(error.localizedDescription)
                }
                
                guard let entity = NSEntityDescription.entity(forEntityName: "Person", in: context) else { return }
                let _: [Person]? = users?.compactMap {
                    let person = Person(entity: entity, insertInto: context)
                    person.cell = $0.cell
                    person.streetName = $0.location.street.name
                    person.streetNum = Int16($0.location.street.number)
                    person.city = $0.location.city
                    person.country = $0.location.country
                    person.name = "\($0.name.first) \($0.name.last)"
                    person.title = $0.name.title
                    person.thumbnail = URL(string: $0.picture.thumbnail)
                    person.largePic =  URL(string: $0.picture.large)
                    person.gender = $0.gender
                    person.dob = $0.dob.date
                    person.email = $0.email
                    return person
                }
            }
            
            if context.hasChanges {
                do {
                    try context.save()
                    delegate?.newDataSaved()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                context.reset()
            }
        }
    }
}
