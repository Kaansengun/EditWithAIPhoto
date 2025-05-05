import Foundation
import SwiftUI
import UIKit

class ImageService {
    
    static let shared = ImageService() //Singleton örneği
    
    private init() {}
    
    func fetchRandomImage() async throws -> Image {
        
        let url = URL(string: "https://picsum.photos/480/640")!
        let (data, _) = try await URLSession.shared.data(from: url) //Tuple döndürüyor. Biz burada sadece veri kısmını kullanıyoruz. (URLRequest) kısmı boş bu sayede gereksiz değişken kullanımının önüne geçiliyor.
        
        guard let uiImage = UIImage(data: data) else { //Burada datayı ilk başta UIImage'a çevirmemiz gerekiyor.
            throw ImageError.invalidData
        }
        
        return Image(uiImage: uiImage)// UIKitten SwiftUI'ya dönüşümü burada gerçekleştiriyoruz.
    }
}

enum ImageError: Error {
    case invalidData
} 
