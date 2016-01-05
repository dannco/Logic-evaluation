class Assertion
    def initialize(str)
        @tokens = Array.new
        @expr = str.strip
        if str.include?"<->" then
            @type = 0
            splitOn = "<->"
        elsif str.include?"->" then
            @type = 1
            splitOn = "->"
        elsif str.include?"|" then
            @type = 2
            splitOn = "|"
        elsif str.include?"&" then
            @type = 3
            splitOn = "&"
        else 
            @type = 4
            @tokens = str.strip
            return
        end
        str.split(splitOn,2).each {
            |t| @tokens.push(Assertion.new(t))
        }
    end 
    def validate(query)
        if @type==0
            b = @tokens[0].validate(query)==@tokens[1].validate(query)
        elsif @type==1
            a = @tokens[0].validate(query)
            b = !a | a&@tokens[1].validate(query)
        elsif @type==2
            b = @tokens[0].validate(query) | @tokens[1].validate(query)
        elsif @type==3
            b = @tokens[0].validate(query) & @tokens[1].validate(query)
        elsif @type==4
            b = query.include? @tokens
            (@tokens[0].include?"!") ? !b : b
        end
        b
    end
    def expr
        @expr
    end
    def describe
        if @type==0
            "#{@tokens[0].expr} must be equivalent to #{@tokens[1].expr}"
        elsif @type==1
            "#{@tokens[0].expr} implies #{@tokens[1].expr}"
        elsif @type==2
            "#{@tokens[0].expr} or #{@tokens[1].expr} must be true"
        elsif @type==3
            "#{@tokens[0].expr} and #{@tokens[1].expr} must be true"
        elsif @type==4
            "#{@tokens[0].expr} must be true"
        end
    end 
end

$assertions = Array.new

def validate(query)
    puts "\nChecking query #{query}"
    $assertions.each {|a|
        if !a.validate(query) then
            puts "#{query} fails assertion #{a.expr}"
            return
        end
    }
    puts "#{query} holds true"
end 

def main
    while true
        input = gets
        if !handleInput(input) then break;
        end
    end
end


def handleInput(string)
    if string.upcase.include?"LOAD" then
        file = /(?:load|LOAD)[\s]+(.+)/.match(string)
        loadFile(file[1])
    elsif string.upcase.include?"CLEAR ASSERTIONS" then
        $assertions = Array.new
        puts "Clearing assertions"
    elsif string.upcase.include?"SHOW ASSERTIONS" then
        puts "Current assertions:"
        $assertions.each {|a| puts a.describe}
    elsif string.upcase.include?"A:" then
        assertion = /A:[\s]*(.+)/.match(string)
        assertion[1].split(",").each {|a|
            createAssertion(a.strip)
            puts "Assertion #{a.strip} created"
        }
    elsif string.upcase.include?"?:" then
        query = /\?:[\s]*(.*)/.match(string)
        validate(query[1].split(",").map!{|i| i.strip})
    elsif string.upcase == "EXIT"
        return false
    end
    true
end
def createAssertion(string)
    $assertions.push(Assertion.new(string))
end

def loadFile(file)
    string = ""

    file = File.open(file,"r")
    while (line = file.gets)
        string += line
    end
    file.close;

    string.scan(/A:[\s]*([^\.]+)\./) {|a|
        createAssertion(a[0])
    }

    queries = string.scan(/\?:[\s]*([^\.]+)\./)

    queries.each {|q| 
        validate(q[0].split(",").map!{|i| i.strip})
    }
end

main


