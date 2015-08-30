
import Foundation


struct stack<T> {
    
    var items = [T]()
    mutating func push(item: T) {
        items.append(item)
    }
    mutating func pop() -> T {
        return items.removeLast()
    }
    mutating func top() -> T? {
        return items.last
    }
    mutating func notEmpty() -> Bool {
        return !items.isEmpty
    }
    mutating func count() -> Int {
        return items.count
    }
    mutating func print() {
        println(items)
    }
}

class CalculatorBrain
{
    private let M_PI = 3.14159265389793
    private var expStack = stack<Character>()
    private var postExp = String()
    private var opStack = stack<Double>()
    
    init(){
        expStack = stack<Character>()
        postExp = String()
        opStack = stack<Double>()
    }
    
    internal func calculate(infixExp: String) -> String {
        var infixExpOfStringArray = stringToArray(infixExp)
        var infixExp = simplifyString(infixExpOfStringArray)
        infixToPostExp(infixExp)
        println(computePostExp(postExp))
        return "\(computePostExp(postExp))"
        
    }
    
    
    private func isOperator(op: Character) -> Bool {
        switch op {
        case "×","÷","+","-","c","s","t":
            return true
        default:
            return false
        }
    }
    
    private func priorityJudge(op: Character) -> Int {
        var value = -1
        switch op {
        case "(":
            value = -1
        case "+","-":
            value = 0
        case "×","÷":
            value = 1
        case "c","s","t":
            value = 2
        default:
            break
        }
        return value
    }
    
    private func infixToPostExp(infixExp:String)
    {
        var i = 0
        for Character in infixExp
        {
            
            if Character >= "0" && Character <= "9" || Character == "." || Character == "π" {
                postExp.append(Character)
            } else if Character == "-" && i == 0 {
                postExp += "-"
            } else if Character == "(" {
                expStack.push(Character)
            } else if Character == ")" {
                while expStack.top() != "("
                {
                    postExp.append(expStack.top()!)
                    expStack.pop()
                }
                expStack.pop()
            } else if (isOperator(Character)) {
                postExp += " "
                while expStack.top() != nil && priorityJudge(Character) <= priorityJudge(expStack.top()!)
                {
                    postExp.append(expStack.top()!)
                    expStack.pop()
                }
                expStack.push(Character)
            }
            i++
            
        }
        
        while expStack.notEmpty() {
            postExp.append(expStack.pop())
        }
        println(postExp)
        
    }
    
    private func simplifyString(strToSimp: Array<String>) -> String {
        
        var res = String()
        
        for var i = 0; i < strToSimp.endIndex ; i++ {
            if strToSimp[i] == "c" && strToSimp[i+1] == "o" && strToSimp[i+2] == "s" {
                res += "c"
                i += 2
            } else if strToSimp[i] == "s" && strToSimp[i+1] == "i" && strToSimp[i+2] == "n" {
                res += "s"
                i += 2
            } else if strToSimp[i] == "t" && strToSimp[i+1] == "a" && strToSimp[i+2] == "n" {
                res += "t"
                i += 2
            } else {
                res += strToSimp[i]
            }
            
        }
        
        return res
    }
    
    private func convertToNumber(str: Array<String>, index: Int) -> (op: Double, returnIndex: Int) {
        var x = 0.0
        var k = 0
        var i: Int = index
        //integer part
        while str[i] >= "0" && str[i] <= "9" {
            x = x*10.0 + ( str[i] as NSString).doubleValue
            i++
        }
        //fractional part
        if str[i] == "." {
            i++
            while str[i] >= "0" && str[i] <= "9" {
                x = x*10.0 + ( str[i] as NSString).doubleValue
                i++
                k++
            }
        }
        while k != 0 {
            x /= 10.0
            k--
        }
        
        if str[i] == "π" {
            x = M_PI
            i++
        }
        return (x,i)
    }
    
    // change String to Array<String>
    private func stringToArray(str: String) -> Array<String> {
        var resArray = Array<String>()
        for Character in str {
            resArray.append(String(Character))
        }
        return resArray
    }
    
    
    private func evaluate(opStyle: Int, op: String) -> Double {
        
        var x1 = 0.0
        var x2 = 0.0
        var val = 0.0
        
        switch opStyle {
        case 1:
            if opStack.count() != 0 {
                x1 = opStack.pop()
                if op == "s" {
                    val = sin(x1*M_PI/180.0)
                } else if op == "c" {
                    val = cos(x1*M_PI/180.0)
                } else if op == "t" {
                    val = tan(x1*M_PI/180.0)
                }
            }
        case 2:
            if opStack.count() >= 2 {
                x1 = opStack.pop()
                x2 = opStack.pop()
                if op == "+" {
                    val = x1 + x2
                } else if op == "-" {
                    val = x2 - x1
                } else if op == "×" {
                    val = x1 * x2
                } else if op == "÷" {
                    val = x2 / x1
                }
            }
        default:
            break
        }
        
        return val
    }
    
    
    private func computePostExp(postExp: String) -> Double {
        
        var tmp = 0.0
        var chg = 1.0
        
        var postExpArray = stringToArray(postExp)
        for var i = postExpArray.startIndex ; i < postExpArray.endIndex ;
        {
            
            if postExpArray[i] >= "0" && postExpArray[i]<="9" || postExpArray[i] == "π" {
                var convert = convertToNumber(postExpArray, index: i)
                if i != 1 {
                    chg = 1.0
                }
                tmp = convert.op * chg
                i = convert.returnIndex
                opStack.push(tmp)
            } else if postExpArray[i] == " " {
                i++
            } else if i == 0 && postExpArray[0] == "-" {
                chg = -1.0
                i++
            }else if isOperator(Character(postExpArray[i])) {
                
                switch postExpArray[i] {
                case "c","s","t":
                    opStack.push(evaluate(1, op: postExpArray[i]))
                    
                case "×","÷","+","-":
                    opStack.push(evaluate(2, op: postExpArray[i]))
                    
                default:
                    break
                }
                i++
            }
        }
        
        return opStack.top()!
        
    }
    
}