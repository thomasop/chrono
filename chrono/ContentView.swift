//
//  ContentView.swift
//  chrono
//
//  Created by Thomas Da Silva on 26/03/2023.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var travail: Int = 0
    @State private var pause: Int = 0
    @State private var didTap:Bool = false
    
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        VStack {
            Text("Pomodoro timer").font(.title)
                .padding(.top, 40)
            Text("Choissisez votre timer de travail et de pause").padding(10)
            HStack {
                VStack {
                    Text("Travail")
                    TextField("Travail", value: $travail, formatter: NumberFormatter())
                }
                VStack {
                    Text("Pause")
                    TextField("Pause", value: $pause, formatter: NumberFormatter())
                }
                
            }
            .padding(.horizontal, 80.0)
            .padding(.top, 50.0)
            .padding(.bottom, 40.0)
            HStack {
                VStack {
                    
                    Text("00:00:00")
                    Button(action: {
                        if(self.didTap == false) {
                            self.didTap = true
                        } else {
                            self.didTap = false
                        }
                    }) {
                        Text("Start")
                    }.padding(10)
                        .background(didTap ? Color.blue : Color.yellow)
                }
            }
            HStack {
            }
            .padding(.bottom, 80.0)
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
