//
//  DropDownView.swift
//  CryptoApp
//
//  Created by Rockz on 29/11/24.
//

import SwiftUI

struct SearchableDropdownMenu<T: Hashable & CustomStringConvertible>: View {
    @State private var isExpanded = false
    @State private var searchText = ""
    @AppStorage("theme") var isDarkMode: Bool = true
    
    @Binding var selectedOption: T?
    let options: [T]
    
    var filteredOptions: [T] {
        if searchText.isEmpty {
            return options
        } else {
            return options.filter { $0.description.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack {
            // Main dropdown button
            Button(action: {
                isExpanded.toggle()
            }) {
                HStack {
                    Text(selectedOption?.description.localizedKey ?? "Select an Option".localizedKey)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                .popover(isPresented: $isExpanded) {
                    ZStack(alignment: .top) {
                        VStack {
                            TextField("Search...", text: $searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.top, 26)
                            
                            ScrollView {
                                ForEach(filteredOptions, id: \.self) { option in
                                    Text(option.description)
                                        .padding()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .foregroundColor(isDarkMode ? .white : .black)
                                        .onTapGesture {
                                            selectedOption = option
                                            isExpanded = false
                                        }
                                }
                            }
                        }
                        .frame(minWidth: 300, maxHeight: 400)
                        .presentationCompactAdaptation(.popover)
                        .padding()
                        .background(isDarkMode ? Color.black : Color.white)
                    }
                }
            }
            .padding()
        }
    }
}
