{
    title = "Upper"
    text = "Create a function that receives a string, and returns the same string, but in all upper case letters."
    hints = [
        "Strings have a method called 'upper'."
        "Read the function out loud: 'uppercase' is (=) a function (->) that takes an 's' and ..."
    ]
    template = "uppercase = s -> s"
    tests = [
        {test="hello",ref="HELLO",fn="uppercase"}
        {test="world!",ref="WORLD!",fn="uppercase"}
    ]
}

