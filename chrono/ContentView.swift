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
    @State private var time:String = ""
    
    enum Flavor: String, CaseIterable, Identifiable {
        case chocolate, vanilla, strawberry
        var id: Self { self }
    }
    
    @State private var selectedFlavor: Flavor = .chocolate
    
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
            Form {
                HStack {
                    TextField("Travail", value: $travail, formatter: NumberFormatter())
                    Stepper(value: $travail, in: 0...60) {
                        EmptyView()
                    }
                }
                HStack {
                    TextField("pause", value: $pause, formatter: NumberFormatter())
                    Stepper(value: $pause, in: 0...60) {
                        EmptyView()
                    }
                }
                Button("Ajouter ce temps") {
                    if (String(travail).count == 1) {
                        time = "0" + String(travail) + ":00"
                    } else {
                        time = String(travail) + ":00"
                    }
                    
                }
                
            }
            
            .padding(.horizontal, 80.0)
            .padding(.top, 50.0)
            .padding(.bottom, 40.0)
            HStack {
                VStack {
                    
                    Text("\(time)")
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
            
        }
        .padding()
    }
    func test() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
