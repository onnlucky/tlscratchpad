{
    title = "Upper The Last Four"
    text = "Create a function that receives a string, and returns the same string, but where the last 4 letters are in upper case."
    hints = [
        "Get subsections of a String using 's[from:to]' syntax; example '\"abcde\"[2:-2] == \"bcd\"'"
        "Put two Strings together using '+'; example '\"a\" + \"b\" == \"ab\"'"
        "Strings have a method called 'upper'"
        "Read the function out loud: 'uppercase' is (=) a function (->) that takes an 's' and ..."
    ]
    template = "upper4 = s -> s"
    tests = [
        {arg="",ref=""}
        {arg="a",ref="A"}
        {arg="test",ref="TEST"}
        {arg="hello",ref="hELLO"}
        {arg="world!",ref="woRLD!"}
        {arg="1",ref="1"}
        {arg="1234567890",ref="1234567890"}
    ]
}

