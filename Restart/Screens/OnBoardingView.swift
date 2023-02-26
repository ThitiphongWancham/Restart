//
//  OnBoardingView.swift
//  Restart
//
//  Created by Thitiphong Wancham on 21/2/2566 BE.
//

import SwiftUI

struct OnBoardingView: View {
    //MARK: - Properties
    
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    
    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 80
    @State private var buttonOffset: CGFloat = 0
    @State private var isAnimating: Bool = false
    @State private var imageOffset: CGSize = CGSize.zero  // is equal to CGSize(width: 0, height: 0)
    @State private var indicatorOpacity: Double = 1.0
    @State private var textTitle: String = "Share."
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    //MARK: - BODY
    var body: some View {
        ZStack {
            Color("ColorBlue").ignoresSafeArea()
            VStack(spacing: 20) {
                //MARK: - HEADER
                Spacer()
                VStack {
                    Text(textTitle)
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .transition(.opacity)
                            // This won't work without the ".id" modifier, because SwiftUI thinks that this still be the same view despite the text is changed, so no transition occur
                        .id(textTitle)
                            // Tell the SwiftUI that this view is NO longer the same view when the view is changed (new id generated). Therefore, the ".transition" can work properly
                    Text("""
                    It's not how much we give but
                    how much love we put into giving.
                    """)
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                } //: HEADER
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : -40)
                .animation(.easeOut(duration: 1), value: isAnimating)
                
                //MARK: - CENTER
                ZStack {
                    // The background circle
                    CircleGroupView(shapeColor: .white, shapeOpacity: 0.2)
                        .offset(x: imageOffset.width * -1.1, y: 0)
                        .blur(radius: abs(imageOffset.width / 5))
                        .animation(.easeOut(duration: 0.5), value: imageOffset)
                    
                    Image("character-1")
                        .resizable()
                        .scaledToFit()
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 1), value: isAnimating)
                        .offset(x: imageOffset.width * 1.1, y: 0)  // Accelerate movement and only horizontal movement
                        .rotationEffect(.degrees(Double(imageOffset.width / 20)))  // Anchor parameter is .center by default
                        .gesture(
                            DragGesture()
                                .onChanged({ gesture in
                                    if abs(imageOffset.width) <= 150 {
                                        imageOffset = gesture.translation
                                        withAnimation(.linear(duration: 0.25)) {
                                            indicatorOpacity = 0
                                            textTitle = "Give."
                                        }
                                    }
                                })
                                .onEnded({ _ in
                                    withAnimation(.easeOut(duration: 0.5)) {
                                        imageOffset = .zero
                                        withAnimation(.linear(duration: 0.25)) {
                                            indicatorOpacity = 1
                                            textTitle = "Share."
                                        }
                                    }
                                })
                        ) //: GESTURE
                } //: CENTER
                .overlay(  // A secondary view in front of the called View
                    Image(systemName: "arrow.left.and.right.circle")
                        .font(.system(size: 44, weight: .ultraLight))
                        .foregroundColor(.white)
                        .offset(y: 20)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 1).delay(2), value: isAnimating)
                        .opacity(indicatorOpacity),  // Hide this image when the user start dragging
                    alignment: .bottom
                )
                
                //MARK: - FOOTER
                ZStack {
                    Capsule()
                        .fill(.white.opacity(0.2))
                    Capsule()
                        .fill(.white.opacity(0.2))
                        .padding(8)
                    Text("Get Started")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: 20)
                    HStack {
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width: buttonOffset + 80)  // because the initial offset = 0, we have to add 80 to it
                        Spacer()
                    } //: SLIDER's BACKGROUND
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color("ColorRed"))
                            Circle()
                                .fill(.black.opacity(0.15))
                                .padding(8)
                            Image(systemName: "chevron.right.2")
                                .font(.system(size: 24, weight: .bold))
                        } //: SLIDER BUTTON
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80, alignment: .center)
                        .offset(x: buttonOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    // Allow only horizontally right direction dragging
                                    if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80 {
                                        buttonOffset = gesture.translation.width
                                    }
                                }
                                .onEnded { _ in
                                    // To make it smoother
                                    withAnimation(.easeOut) {
                                        if buttonOffset > buttonWidth / 2 {
                                            hapticFeedback.notificationOccurred(.success)
                                            playSound(sound: "chimeup", type: "mp3")
                                            buttonOffset = buttonWidth - 80
                                            isOnboardingViewActive = false
                                        } else {
                                            hapticFeedback.notificationOccurred(.warning)
                                            buttonOffset = 0
                                        }
                                    }
                                }
                        ) //: GESTURE
                        Spacer()
                    } //: SLIDER
                } //: FOOTER
                .frame(width: buttonWidth, height: 80, alignment: .center)
                .padding()
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 40)
                .animation(.easeOut(duration: 1), value: isAnimating)
            } //: VSTACK
        } //: ZSTACK
        .onAppear {  // To create an animation after the View did appear
            isAnimating = true
        }
        .preferredColorScheme(.dark)  // Set the status bar at the top to display in dark mode (white foreground color)
    }
}

//MARK: - PREVIEW

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
