import Foundation

enum PersonError: Error {
    case unexpected(description: String)
    case server(code: Int)
    case parsingError
    case dataFetchingError
    case localDBFail
}

typealias PersonsResult = Result<[PersonModel], PersonError>

struct PersonRepository {
    let remoteDataSource = PersonRemoteDataSource()
    let localDataSource = PersonLocalDataSource()
    
    func fetchAll() async -> PersonsResult {
        let remoteResult = await remoteDataSource.fetchAll()
        switch remoteResult {
        case .success(let remotePersons):
            debugPrint("Retrieved data from a remote data source")
            return .success(remotePersons)
        case .failure(_):
            return fallbackToLocalDataSource()
        }
    }
    
    private func fallbackToLocalDataSource() -> PersonsResult {
        let localResult = localDataSource.fetchAll()
        switch localResult {
        case .success(let localPersons):
            debugPrint("Retrieved data from the local data source")
            return .success(localPersons)
        case .failure(let error):
            return .failure(error)
        }
    }
}
