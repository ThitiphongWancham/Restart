//
//  ContentView.swift
//  Restart
//
//  Created by Thitiphong Wancham on 21/2/2566 BE.
//

import SwiftUI

struct ContentView: View {
    // This View is our central hub of our application, so it needs to have a property that will hold our application state.
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    
    var body: some View {
        ZStack {
            if isOnboardingViewActive {
                OnBoardingView()
            } else {
                HomeView()
            }
        } //: ZStack
        .animation(.easeOut, value: isOnboardingViewActive)  // Animate screen transition
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
