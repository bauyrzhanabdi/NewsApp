import UIKit

final class NetworkService {
    static let shared: NetworkService = .init()
    
    struct Constants {
        static let url = URL(string: "https://newsapi.org/v2/everything?q=apple&from=2023-02-03&to=2023-02-03&sortBy=popularity&apiKey=18dc2d545274469aac1a618a80c8fbbe")
    }
    
    private init() {}
    
    public func getContent(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.url else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(Response.self, from: data)
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
