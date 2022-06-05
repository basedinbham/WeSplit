//
//  ContentView.swift
//  WeSplit
//
//  Created by Kyle Warren on 6/5/22.
//

import SwiftUI

struct ContentView: View {
    // @State tells SwiftUI to store the value somewhere that can be changed freely, outside of our struct.
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    // Property wrapper to determine if cehck amount box should have focus - should be receiving text input from user
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    let localCurrency: FloatingPointFormatStyle<Double>.Currency = .currency(code: Locale.current.currencyCode ?? "USD")
    
    // Computed property getting input data ready
    var totalPerPerson: Double {
        // Converting into double because it has to be used along side check amount (double)
        // numberOfPeople + 2 since numberOfPeople is off by 2; when storing value 3 it means 5. Range 2 to 100 counts from 0
        // which is why we need to add 2.
        let peopleCount = Double(numberOfPeople + 2)
        // Converting into double because it has to be used along side check amount (double)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var checkTotal: Double {
        let tipValue = checkAmount / 100 * Double(tipPercentage)
        let checkTotal = checkAmount + tipValue
        
        return checkTotal
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    // Full local currency code left for reference
                    TextField("Amount", value: $checkAmount, format:
                        .currency(code: Locale.current.currencyCode ?? "USD"))
                        .keyboardType(.decimalPad)
                        // Attach to text field so SwiftUI will know where the text field is focused amountIsFocused should be true
                        .focused($amountIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section {
                    Picker("Tip Percentage", selection:  $tipPercentage) {
                        // id: \.self each of our numbers are unique so identify them by that
                        ForEach(tipPercentages, id: \.self) {
                            // convert each number ot be a text view using the format of percent
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                    // Header trailing closure containing text to display above the section
                } header: {
                    Text("How much tip do you want to leave?")
                }
                
                Section {
                    Text(checkTotal, format: localCurrency)
                } header: {
                    Text("Total Cost of Check")
                }
                
                Section {
                    Text(totalPerPerson, format: localCurrency)
                } header: {
                    Text("Amount Per Person")
                }
                
                
            }
            // We can send a string to the navigationTitle() modifier to place a title at the top of our navigation view.
            // You should always attach this modifier to the view inside the navigation view rather than the navigation view itself.
            .navigationTitle("WeSplit")
            // toolbar() modifier lets us specify toolbar items for view. Toolbar items might appear in various places on screen
            // in navigation bar at top, in special toolbar area at bottom, etc...
            .toolbar {
                // ToolbarItemGroup lets us place one or more buttons in specific location & this is where we get to specify we
                // want a keyboard toolbar - toolbar that is attached to keyboard so it will auto appear / disappear w keyboard
                ToolbarItemGroup(placement: .keyboard) {
                    // Flexible space by default - wherever spacer placed will auto push other views to one side. By placing first
                    // in toolbar will cause button to be pushed to the right
                    Spacer()
                    // Button view used here displays some tappable text I.E 'Done'. Also need to provide it with some code
                    // to run when pressed - sets amountIsFocused to false so that keyboard dismisses

                    Button("Done") {
                        // Closure running when buttom is tapped
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

