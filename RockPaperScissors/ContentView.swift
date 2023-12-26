//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Vittorio Sassu on 22/12/23.
//

import SwiftUI

enum GameObject: String, CaseIterable {
    case rock = "✊"
    case paper = "✋"
    case scissors = "✌️"
}

struct ContentView: View {
    @State private var win = Bool.random()
    @State private var isMoveAlertPresented = false
    @State private var isGameEndedPresented = false
    @State private var alertTitle = ""
    @State private var chosenObject = GameObject.allCases[Int.random(in: 0..<3)]
    @State private var numberOfQuestions = 1
    var currentAnswers: [GameObject] {
        switch chosenObject {
        case .rock:
            return [.paper, .scissors].shuffled()
        case .paper:
            return [.rock, .scissors].shuffled()
        case .scissors:
            return [.rock, .paper].shuffled()
        }
    }
    @State private var score = 0
    var shouldYouWin: String {
        win ? "you should WIN" : "you should LOSE"
    }
    var correctAnswer: GameObject {
        switch (chosenObject, win) {
        case (.rock, true):
            return .paper
        case (.rock, false):
            return .scissors
        case (.paper, true):
            return .scissors
        case (.paper, false):
            return .rock
        case (.scissors, true):
            return .rock
        case (.scissors, false):
            return .paper
        }
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: .purple, location: 0.3),
                .init(color: .green, location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack(spacing: 10) {
                Spacer()
                Spacer()
                VStack(spacing: 20) {
                    Text("I play \(chosenObject.rawValue) and \(shouldYouWin)")
                        .multilineTextAlignment(.center)
                        .font(.title.bold())
                        .foregroundStyle(.primary)
                    ForEach(currentAnswers, id: \.self) { object in
                        Button {
                           onAnswer(selected: object)
                        } label: {
                            Text(object.rawValue)
                                .font(.largeTitle.bold())
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("Score: \(score)")
                Text("Question: \(numberOfQuestions)")
                Button {
                    playAgain()
                } label: {
                    Text("Reset Game")
                        .foregroundStyle(.purple)
                }
            }
            .padding()
        }
        .alert(alertTitle, isPresented: $isMoveAlertPresented) {
            Button("Continue", action: getNewTurn)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("End Game", isPresented: $isGameEndedPresented) {
            Button("Yes", role: .cancel, action: playAgain)
            Button("No", role: .destructive, action: {exit(0)})
        } message: {
            Text("Your game ends at score \(score). Do you wanna play again?")
        }
    }
        
    
    func onAnswer(selected selectedAnswer: GameObject) {
        check(selected: selectedAnswer)
        if numberOfQuestions < 10 {
            isMoveAlertPresented = true
        } else {
            isGameEndedPresented = true
        }
    }
    
    func getNewTurn() {
        numberOfQuestions += 1
        win.toggle()
        chosenObject = GameObject.allCases[Int.random(in: 0..<3)]
    }
    
    func check(selected selectedAnswer: GameObject) {
        if selectedAnswer == correctAnswer {
            score += 1
            alertTitle = "Correct Move"
        } else {
            score -= 1
            alertTitle = "Wrong Move"
        }
    }
    
    func playAgain() {
        numberOfQuestions = 1
        score = 0
        win.toggle()
        chosenObject = GameObject.allCases[Int.random(in: 0..<3)]
    }
}

#Preview {
    ContentView()
}
