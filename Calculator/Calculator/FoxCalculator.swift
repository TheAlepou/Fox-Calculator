//
//  FoxCalculator.swift
//  Calculator
//
//  Created by Luca on 28.01.2025.
//

import Foundation
import SwiftUI

enum CalcButton: String {
    case one = "1", two = "2", three = "3", four = "4", five = "5", six = "6", seven = "7", eight = "8", nine = "9", zero = "0"
    case add = "+", subtract = "-", multiply = "x", divide = "/", equal = "=", clear = "AC", decimal = ".", percent = "%", negative = "-/+"
}

struct FoxCalculator: View {
    @State private var value = "0"
    @State private var currentOperation: CalcButton? = nil
    @State private var firstOperand: Double? = nil
    @State private var isTypingNumber = false
    @State private var buttonPressSequence: [CalcButton] = []
    @State private var showSecretButton = false
    
    let secretSequence: [CalcButton] = [.seven, .eight, .nine, .add]
    
    var body: some View {
        let buttons: [[CalcButton]] = [
            [.clear, .negative, .percent, .divide],
            [.seven, .eight, .nine, .multiply],
            [.four, .five, .six, .subtract],
            [.one, .two, .three, .add],
            [.decimal, .zero, .equal]
        ]
        
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(value)
                        .bold()
                        .font(.system(size: 64))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                .padding()
                
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                handleButtonPress(item)
                            }) {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(width: 70, height: 70)
                                    .background(itemBackgroundColor(item))
                                    .foregroundColor(.white)
                                    .cornerRadius(35)
                            }
                        }
                    }
                }
                
                if showSecretButton {
                    NavigationLink(destination: ContentView()){
                        Button(action: {
                            print("Secret button activated!")
                        }) {
                            Text("Secret")
                                .font(.system(size: 24))
                                .frame(width: 150, height: 70)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(35)
                        }
                    }
                    .padding(.top, 20)
                }
            }
        }
    }
    
    private func handleButtonPress(_ button: CalcButton) {
        buttonPressSequence.append(button)
        
        if buttonPressSequence == secretSequence {
            showSecretButton = true
            buttonPressSequence = []
        } else if !secretSequence.starts(with: buttonPressSequence) {
            buttonPressSequence = []
        }
        
        switch button {
        case .add, .subtract, .multiply, .divide:
            handleOperation(button)
        case .equal:
            handleEqual()
        case .clear:
            resetCalculator()
        case .decimal:
            handleDecimal()
        case .negative:
            toggleNegative()
        case .percent:
            applyPercentage()
        default:
            handleNumber(button)
        }
    }
    
    private func handleNumber(_ button: CalcButton) {
        let number = button.rawValue
        if isTypingNumber {
            value += number
        } else {
            value = number
            isTypingNumber = true
        }
    }
    
    private func handleOperation(_ button: CalcButton) {
        if let firstValue = Double(value) {
            firstOperand = firstValue
            currentOperation = button
            isTypingNumber = false
        }
    }
    
    private func handleEqual() {
        if let operation = currentOperation,
           let firstValue = firstOperand,
           let secondValue = Double(value) {
            let result: Double
            switch operation {
            case .add:
                result = firstValue + secondValue
            case .subtract:
                result = firstValue - secondValue
            case .multiply:
                result = firstValue * secondValue
            case .divide:
                result = secondValue == 0 ? 0 : firstValue / secondValue
            default:
                return
            }
            value = formatResult(result)
            resetCalculatorPartial()
        }
    }
    
    private func resetCalculator() {
        value = "0"
        currentOperation = nil
        firstOperand = nil
        isTypingNumber = false
    }
    
    private func resetCalculatorPartial() {
        currentOperation = nil
        firstOperand = nil
        isTypingNumber = false
    }
    
    private func handleDecimal() {
        if !value.contains(".") {
            value += "."
        }
    }
    
    private func toggleNegative() {
        if let doubleValue = Double(value) {
            value = formatResult(-doubleValue)
        }
    }
    
    private func applyPercentage() {
        if let doubleValue = Double(value) {
            value = formatResult(doubleValue / 100)
        }
    }
    
    private func formatResult(_ result: Double) -> String {
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(result))
        } else {
            return String(result)
        }
    }
    
    //Colors for buttons
    private func itemBackgroundColor(_ button: CalcButton) -> Color {
        switch button {
        case .add, .subtract, .multiply, .divide, .equal:
            return .orange
        case .clear, .negative, .percent:
            return .gray
        default:
            return Color(red: 0.33, green: 0.33, blue: 0.33)
        }
    }
}
