//
//  ContentView.swift
//  MICHAELMCGINNIS-GuessTheFlag
//
//  Created by Michael Mcginnis on 2/2/22.
//

import SwiftUI

struct FlagImage: View{
    var images: String
    var body: some View{
        Image(images)
            .renderingMode(.original)
                .clipShape(Capsule())
                .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    //shows alerts
    @State private var showingScore = false
    @State private var showingEndScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var flagChosen = ""
    @State private var questionCounter = 0
    //animations
    @State private var animationAmount = 0.0
    @State private var animationOpacity = 1.0
    @State private var animateOpacity = false
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            VStack{
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
            VStack(spacing: 15){
                VStack{
                    Text("Tap the flag of").font(.subheadline.weight(.heavy)).foregroundStyle(.secondary)
                    Text(countries[correctAnswer]).font(.largeTitle.weight(.semibold))
                }
                ForEach(0..<3){ number in
                    Button{
                        flagChosen = countries[number]

                        withAnimation{
                            animationAmount += 360
                            animationOpacity -= 0.75
                            animateOpacity = true
                        }
                        flagTapped(number)

                    } label: {
                        flagChosen == countries[number] ?
                        FlagImage(images: countries[number])
                            .rotation3DEffect(.degrees(animationAmount), axis: (x : 0, y: 1, z : 0))
                            .opacity(1.0)
                            .animation(
                                .easeInOut(duration: 1)
                                    .repeatCount(3, autoreverses: true),          value: animationOpacity
                            )
                        :
                        FlagImage(images: countries[number])
                            .rotation3DEffect(.degrees(0), axis: (x : 0, y: 0, z : 0))
                            .opacity(animateOpacity ? 0.25 : 1)
                            .animation(
                                .easeInOut(duration: 1)
                                    .repeatCount(3, autoreverses: true),
                                value: animationOpacity
                            )
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(userScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
        }
            .padding()
        }
        
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue"){
                askQuestion()
            }
        } message: {
            if scoreTitle == "Wrong"{
                Text("You chose: \(flagChosen)")
            }
            else{
                Text("Correct! Your score is \(userScore)")
            }
        }
        
        .alert("Game Fin!", isPresented: $showingEndScore){
            Button("Reset Game", action: resetGame)
        } message: {
            Text("You scored: \(userScore)")
        }
    }
    //updates user score and displays alerts
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            userScore += 1
            scoreTitle = "Correct"
        } else {
            userScore -= 1
            scoreTitle = "Wrong"
        }
        questionCounter += 1
        if questionCounter == 8{
            showingEndScore = true
        }
        else{
        showingScore = true
        }
        //comment
    }
    func askQuestion(){
        animateOpacity = false
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    func resetGame(){
        userScore = 0
        questionCounter = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
/*
 comment
 for
 gitlearning
 */
