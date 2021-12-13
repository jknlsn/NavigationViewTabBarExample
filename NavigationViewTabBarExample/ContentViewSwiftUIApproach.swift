//
//  ContentViewSwiftUIApproach.swift
//  NavigationViewTabBarExample
//
//  Created by Jake Nelson on 13/12/21.
//

import SwiftUI

struct ContentViewSwiftUIApproach: View {
    
    // This has issues with rearranging tabs, visual glitches
    // not remembering order and so on
    
    var body: some View {
        TabView{
            ForEach(0..<8){
                index in
                Group{
                    if index < 4 {
                        NavigationView{
                            List(0..<50){
                                NavigationLink("\($0)", destination: Text("\($0)"))
                            }
                            .navigationBarTitle("\(index) title")
                        }
                    }
                    else {
                        List(0..<50){
                            NavigationLink("\($0)", destination: Text("\($0)"))
                        }
                        .navigationBarTitle("\(index) title")
                    }
                }
                .tabItem {
                    Image(systemName: "\(index).square.fill")
                    Text("\(index)")
                }
            }
        }
    }
}

struct ContentViewSwiftUIApproach_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewSwiftUIApproach()
    }
}
