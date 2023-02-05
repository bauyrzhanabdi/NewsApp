import UIKit

struct Response: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let websiteUrl: String?
    let imageUrl: String?
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case source, title, description
        case websiteUrl = "url"
        case imageUrl = "urlToImage"
        case date = "publishedAt"
    }
    
    struct Source: Codable {
        let name: String
    }
}
