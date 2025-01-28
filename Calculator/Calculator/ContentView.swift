//
//  ContentView.swift
//  Calculator
//
//  Created by Luca on 27.01.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack{
                
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image("Alepou")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    
                    NavigationLink(destination: FoxCalculator()) {
                        Text("Enter The World of Math!")
                            .foregroundStyle(Color.white)
                            .font(.title)
                            .padding()
                            .background(Color.pink.clipShape(.rect(cornerRadius: 15)))
                    }
                    HStack{
                        
                    }

                    
                }
                VStack {
                    Text("Fox Calculator by TheAlepou")
                        .foregroundColor(.white)
                    //Spacer(bottom)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                }
                .padding()
            }
        }
        
    }
}

#Preview {
    ContentView()
}
