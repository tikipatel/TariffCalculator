//
//  ContentView.swift
//  TariffCalculator
//
//  Created by Pratik Patel on 3/7/25.
//

import SwiftUI

struct ContentView: View {
  @State var showTariff = false
  var body: some View {
    VStack {
      Button(
        action: {
          showTariff = true
        }, label: {
          Text("Do I have tariff?")
        }
      )
      .buttonStyle(BorderedProminentButtonStyle())
    }
    .padding()
    .alert("TARIFF!", isPresented: $showTariff, actions: {

    })
    .popover(isPresented: .constant(false)) {
      VStack {
        Text("Yes, you have tariff")
      }
    }
  }
}

#Preview {
  ContentView()
}
