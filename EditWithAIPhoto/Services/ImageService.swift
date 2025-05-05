import Foundation
import SwiftUI
import UIKit
//Burada AsyncImage kullanmak mantıklı değil çünkü bu yapı internet URL'i üzerindeki resmi doğrudan kullanmak için optimize edilmiş bir yapıdır. Biz daha çok resmi değiştirme işlemlerini vs. gibi ölçeklendirme yapacağız.

class ImageService {
    
    static let shared = ImageService() //Singleton örneği
    
    private init() {}
    
    func fetchRandomImage() async throws -> UIImage {
        
        let url = URL(string: "https://picsum.photos/480/640")!
        try await Task.sleep(nanoseconds: 100_000_000) // Burada 0.1 saniye bekleme yaparak projenin performansında bir artış yapmak amaçlanmaktadır
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let uiImage = UIImage(data: data) else {
            throw ImageError.invalidData
        }
        
        return uiImage
    }
}

enum ImageError: Error {
    case invalidData
}
