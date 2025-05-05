import Foundation
import SwiftUI

@MainActor
class ContentViewModel: ObservableObject {
    
    @Published var selectedImage: Image? = nil
    @Published var processedImage: Image? = nil
    @Published var isLoading: Bool = true
    @Published var showOriginal: Bool = false
    
    let filterOptions: [FilterOption] = [
        FilterOption(name: "AVATAR", imageName: "image"),
        FilterOption(name: "BELLE 01", imageName: "image2"),
        FilterOption(name: "BELLE 02", imageName: "image3"),
        FilterOption(name: "BELLE 03", imageName: "image4"),
        FilterOption(name: "AURA 01", imageName: "image5"),
        FilterOption(name: "AURA 02", imageName: "image6"),
        FilterOption(name: "ZOMBIE", imageName: "image7"),
        FilterOption(name: "TOON 01", imageName: "image8"),
        FilterOption(name: "TOON 02", imageName: "image9"),
        FilterOption(name: "TOON 03", imageName: "image10"),
        FilterOption(name: "TOON 04", imageName: "image11"),
        FilterOption(name: "POP 01", imageName: "image12"),
        FilterOption(name: "POP 02", imageName: "image13"),
        FilterOption(name: "POP 03", imageName: "image14"),
        FilterOption(name: "ART 01", imageName: "image15"),
        FilterOption(name: "ART 02", imageName: "image16"),
        FilterOption(name: "ART 03", imageName: "image17")
    ]
    
    init() {
        Task {
            await fetchRandomImage()
        }
    }
    
    func fetchRandomImage() async {
        //Burada Task yapısı da kullnılabilir.
        
        isLoading = true
        
        do {
            processedImage = try await ImageService.shared.fetchRandomImage()
        } catch {
            print("API hatası: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
} 
