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
            ZStack {
                VStack(spacing: 0) {
                    // Ana görüntü alanı
                    ZStack {
                        if let image = viewModel.showOriginal ? viewModel.selectedImage : (viewModel.processedImage ?? viewModel.selectedImage) { // İlk ifade true ise ?'den hemen sonrası çalışır yoksa parantezin içine girer. Parantezin içinde de aynı mantığı işler.
                            image
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
                        .disabled(viewModel.isLoading)
                    
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
                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(2)
                        Text("Loading template...")
                            .foregroundColor(.white)
                            .padding(.top, 15)
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3))
                    .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
