import Foundation

struct PersonRepository {
    let remoteDataSource = PersonRemoteDataSource()
    
    func fetchAll(completion: @escaping (Result<[PersonModel], PersonError>) -> Void) {
        return remoteDataSource.fetchAll(completion: completion)
    }
}
