//
//  LottieViewComponent.swift
//  TravelApp
//
//  Created by Agfi on 27/05/24.
//

import SwiftUI
import Lottie

struct LottieViewComponent: View {
    @State var playbackMode = LottiePlaybackMode.playing(LottiePlaybackMode.PlaybackMode.fromProgress(0, toProgress: 1, loopMode: .loop))

    var body: some View {
        VStack {
            LottieView(animation: .named("loading3"))
                .playbackMode(playbackMode)
                .animationDidFinish { _ in
                    // No need to change playbackMode here, it will loop continuously
                }
        }
    }
}

#Preview {
    LottieViewComponent()
}
