//
//  ContentView.swift
//  EditWithAIPhoto
//
//  Created by Kaan Şengün on 27.03.2025.
//
import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView { 
            ZStack { // ZStack yapısını kullanarak loading göstergesini tüm ekranı kaplayacak 
                VStack(spacing: 0) {
                    // Ana görüntü alanı
                    ZStack {
                        if let image = viewModel.showOriginal ? viewModel.selectedImage : (viewModel.processedImage ?? viewModel.selectedImage) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.6)
                                .background(Color(.systemGray6))
                        } else {
                            Rectangle()
                                .fill(Color(.systemGray6))
                                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.6)
                                .overlay(
                                    VStack {
                                        Image(systemName: "photo")
                                            .font(.largeTitle)
                                            .foregroundColor(.gray)
                                        Text("")
                                        Text("Fotoğraf")
                                            .foregroundColor(.gray)
                                    }
                                )
                        }
                    }
                    
                    // Original image toggle
                    Toggle("Original image", isOn: $viewModel.showOriginal)
                        .padding()
                        .background(Color(.systemGray6))
                        .disabled(viewModel.isLoading) //Yükleme işlemi devam ediyorsa butonlar devre dışı bırakılır.
                                                
                    // Filter options
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.filterOptions) { filter in
                                Button(action: {
                                    Task {
                                        await viewModel.fetchRandomImage()
                                    }
                                }) {
                                    VStack {
                                        Image(filter.imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipped()
                                            .cornerRadius(10)
                                        Text(filter.name)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .disabled(viewModel.isLoading)
                            }
                        }
                        .padding()
                    }
                    .background(Color(.systemBackground))
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                        }
                        .disabled(viewModel.isLoading)
                    }
                    ToolbarItem(placement: .principal) {
                        Text("Edit")
                            .font(.headline)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {}) {
                            Image(systemName: "checkmark")
                        }
                        .disabled(viewModel.isLoading)
                    }
                }
                
                // Loading overlay tüm ekranı kaplıyor
                if viewModel.isLoading { //Yükleme işlemi devam ediyorsa loading ekranı gösterilir.
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(2)
                            .tint(.white) //Dönen yuvarlağın rengi beyaz yapıldı.
                        Text("Loading template...")
                            .foregroundColor(.white)
                            .padding(.top, 15)
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3))
                    .edgesIgnoringSafeArea(.all) //Yükleme ekranının tüm ekranı kaplaması için.
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
