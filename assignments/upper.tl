{
    title = "Upper"
    text = "Create a function that receives a string, and returns the same string, but in all upper case letters."
    hints = [
        "Strings have a method called 'upper'."
        "Read the function out loud: 'uppercase' is (=) a function (->) that takes an 's' and ..."
    ]
    template = "uppercase = s -> s"
    tests = [
        {arg="hello",ref="HELLO"}
        {arg="world!",ref="WORLD!"}
        {arg="1234567890",ref="1234567890"}
    ]
}

