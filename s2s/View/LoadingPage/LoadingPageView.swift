//
//  LoadingPageView.swift
//  Snap2Spoon
//
//  Created by Alex Rowshan on 11/13/24.
//

import SwiftUI

struct LoadingPageView: View {
    @State private var rotation: Double = 0
    @State private var showSuccess = false
    
    var body: some View {
        ZStack {
            Color(hex: "#FCFCFC")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Snap2Spoon")
                    .font(.custom("Scripto", size: 32))
                    .foregroundColor(Color(hex: "#7FBD61"))
                    .padding(.top, 40)
                    .fontWeight(.bold)
                
                Spacer().frame(height: 90)
                
                ZStack {
                    ForEach(0..<5) { index in
                        let angle = Double(index) * (360.0 / 5.0)
                        let radius: CGFloat = 170
                        
                        Image(getImageName(index))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 100)
                            .position(
                                x: 200 + radius * cos(CGFloat(angle + rotation) * .pi / 180),
                                y: 200 + radius * sin(CGFloat(angle + rotation) * .pi / 180)
                            )
                            .rotationEffect(.degrees(-rotation))
                    }
                    
                    VStack {
                        Text("Creating Recipe...")
                            .font(.custom("Avenir", size:18))
                            .foregroundColor(Color(hex: "#80D05B"))
                            .italic()
                            .bold()
                        
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 200, height: 200)
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 5, y: 5)

                            Circle()
                                .fill(Color(hex: "#80D05B").opacity(0.77))
                                .frame(width: 180, height: 180)
                            
                            VStack {
                                Image("receipt2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 130, height: 130)
                            }
                        }
                    }
                }
                .frame(height: 400)
                                
                Spacer()
            }
            
            // Success overlay that appears briefly before transitioning
            if showSuccess {
                ZStack {
                    Color.black.opacity(0.7)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(Color(hex: "#7cd16b"))
                        
                        Text("Recipe Created!")
                            .font(.custom("Avenir", size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(40)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
                .transition(.opacity)
            }
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 8).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
    
    private func getImageName(_ index: Int) -> String {
        let images = ["carrot", "bread", "cheese", "egg", "milk"]
        return images[index]
    }
}

struct RecipeGenerationViewer: PreviewProvider {
    static var previews: some View {
        LoadingPageView()
    }
}

struct RecipeGenerationView: View {
    let image: UIImage
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            if recipeViewModel.isLoading {
                LoadingPageView()
            }
        }
        .onAppear {
            recipeViewModel.generateRecipesFromImage(image)
        }
        .onChange(of: recipeViewModel.recipes) { newRecipes in
            if !recipeViewModel.isLoading && !newRecipes.isEmpty {
                // Show success briefly, then navigate and dismiss
                withAnimation {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        dismiss()
                        NotificationCenter.default.post(name: Notification.Name("SwitchToRecipesTab"), object: nil)
                    }
                }
            }
        }
        .alert("Error",
               isPresented: Binding<Bool>(
                get: { recipeViewModel.errorMessage != nil },
                set: { _ in recipeViewModel.errorMessage = nil }
               )
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(recipeViewModel.errorMessage ?? "")
        }
    }
}

struct ChatRecipeGenerationView: View {
    let ingredients: [String]
    let allergyText: String
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            if recipeViewModel.isLoading {
                LoadingPageView()
            }
        }
        .onAppear {
            recipeViewModel.generateRecipesFromChat(ingredients: ingredients, allergyText: allergyText)
        }
        .onChange(of: recipeViewModel.recipes) { newRecipes in
            if !recipeViewModel.isLoading && !newRecipes.isEmpty {
                // Show success briefly, then navigate
                withAnimation {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        dismiss()
                        NotificationCenter.default.post(name: Notification.Name("SwitchToRecipesTab"), object: nil)
                    }
                }
            }
        }
        .alert("Error",
               isPresented: Binding<Bool>(
                   get: { recipeViewModel.errorMessage != nil },
                   set: { _ in recipeViewModel.errorMessage = nil }
               )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(recipeViewModel.errorMessage ?? "")
        }
    }
}
