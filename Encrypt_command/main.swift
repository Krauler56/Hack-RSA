import Darwin
import Foundation
import Cocoa
var rsaCods:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~!@#$%^&*()_+`1234567890-=<>?:\"{}|,./;'[]\\ ĄĆĘŁŃÓŚŹŻąćęłńóśźż"
var content:String = ""
if let url = URL(string: "http://xor.math.uni.lodz.pl/~frydrych/crypto/e/Ex_0000011_RSA.txt")
{
    do{
         content = try String(contentsOf:url)
        content=content.replacingOccurrences(of: "/* ******************************************************************** */", with: "")
        content=content.replacingOccurrences(of: "( n, e ) = ( ", with: "")
        content=content.replacingOccurrences(of: ",", with: "")
        content=content.replacingOccurrences(of: "):", with: "")
        content=String(content.dropFirst(19))
       //print(content)
    }
    catch
    {
        
    }
}
else
{
    print("URL IS BAD")
}

precedencegroup ExponentiationPrecedence {
    associativity: right
    higherThan: MultiplicationPrecedence
}

infix operator ** : ExponentiationPrecedence

func ** (_ base: Double, _ exp: Double) -> Double {
    return pow(base, exp)
}


func p_and_q(n:Double) ->[Double]
{
    var data:[Double] = []

    for i in 2...Int(n)-1{
    if n.truncatingRemainder(dividingBy: Double(i)) == 0{
            data.append(Double(i))
    }
}
    return data
}

    func euler(p:Double, q:Double)->Double{
return (p - 1) * (q - 1)
    }
    func  private_index(e:Double, euler_v:Double)->Double{
        for i in 2...Int(euler_v){
            if Int(i) * Int(e) % Int(euler_v)  == 1{
                return Double(i)
                
            }
        }
        return 1.0
    }
func smt(a:Int,x:Int,c:Int)->Int
{
    var b:Int = 1
    var l:Int = x
    var i:Int = a
    while l>0
    {
        if x % 2 == 1
        {
            l = l - 1
            b = (b*i)%c
        }
        else
        {
            l = l/2
            i = (i*i)%c
        }
    }
    return b
}
    func decipher(d:Double, n:Double, c:Double)->Int{
        return smt(a: Int(c), x: Int(d), c: Int(n))//Int(c ** d) % Int(n)//Formula Eulera
    }
var e:Double = 7
var n:Double = 15089
func Decode(_c:Double)->Void{
    var c:Double = _c


    var p_and_q_v:[Double] = p_and_q(n: n)


    var euler_v:Double = euler(p: p_and_q_v[0], q: p_and_q_v[1])

    var d:Double = private_index(e: e, euler_v: euler_v)

    var plain:Int = decipher(d: d, n: n, c: c)
    print(Array(rsaCods)[plain-2],terminator:"")
}
var counter:Int=0
var smtt = content.components(separatedBy: [" "," "])
//var numbersAsStrings = matchesForRegexInText(regex: "\\d+", text: content)
//var numbersAsInts = numbersAsStrings.map { $0 }
let strArr = content.characters.split{$0 == " "}.map(String.init)

for item in strArr {
    let components = item.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
    
    let part = components.joined(separator: "")
    
    if let intVal = Int(part) {
        //print("this is a number -> \(intVal)")
        if(counter==0)
        {
            
            n=Double(intVal)
        }
        else if(counter==1)
        {
            e=Double(intVal)
        }
        else {
            
            Decode(_c: Double(intVal))
        }
        counter=counter+1
    }
}
print("")
