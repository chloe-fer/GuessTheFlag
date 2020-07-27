//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Chloe Fermanis on 17/6/20.
//  Copyright © 2020 Chloe Fermanis. All rights reserved.
//

import SwiftUI

struct FlagImage: View {
    
    var name: String

    var body: some View {
            
        Image(name)
            .renderingMode(.original)
            .clipShape(Rectangle())
            .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var score = 0
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    
    @State private var rotationAmount = 0.0
    @State private var opacityAmount = 1.0
    
    var body: some View {
        ZStack {
            //LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
            Color.white
            .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                Spacer()
                VStack(spacing: 20) {
                    Text("TAP THE FLAG OF")
                        .font(Font.custom("Futura", size: 20))
                        .fontWeight(.black)


                    Text(countries[correctAnswer])
                        .font(Font.custom("Futura", size: 40))
                        .fontWeight(.black)
                    }
                
                ForEach(0 ..< 3) { number in
                    Button(action:  {
                        // flag was tapped
                        self.flagTapped(number)
                        
                    }) {
                        FlagImage(name: self.countries[number])

                    }
                    .rotation3DEffect(.degrees((number == self.correctAnswer) ? self.rotationAmount : 0.0), axis: (x: 0, y: 1, z: 0))
                    .opacity(number == self.correctAnswer ? 1 : self.opacityAmount)
                }

                Text("SCORE: \(score)")
                    .font(Font.custom("Futura", size: 25))
                    .fontWeight(.black)

                Spacer()
            }
        }

        .alert(isPresented: $showingScore) {

            Alert(title: Text(scoreTitle), message: Text("\(scoreMessage)"), dismissButton: .default(Text("Continue")) { self.askQuestion()
            })
        }
      
    }
    
    
    func flagTapped(_ number: Int) {
                
        if number == correctAnswer {
            
            withAnimation(.interpolatingSpring(stiffness: 20, damping: 5)) {
                self.rotationAmount = 360
                self.opacityAmount = 0.25

            }
            score += 1
            scoreTitle = "Correct"
            scoreMessage = "Your score is \(score)"
        } else {
            score -= 1
            opacityAmount = 0.0
            scoreTitle = "Wrong"
            scoreMessage = "That was the flag of \(countries[number])"
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        opacityAmount = 1.0
        rotationAmount = 0.0

       }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
