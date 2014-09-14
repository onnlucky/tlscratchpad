{
    title = "Adding"
    text = "Given two numbers, create a function that returns the result of adding the two numbers."
    hints = [
        "Read the function out loud: 'uppercase' is (=) a function (->) that takes an 's' and ..."
        "Adding is done by '+', e.g. '1 + 1'"
        "Function think of two names before the arrow (->) and write addition using those names, like in algebra."
    ]
    template = "add = n1, n2 ->"
    tests = [
        {args=[1,2],ref=3}
        {args=[5,7],ref=12}
        {args=[100, 0],ref=100}
        {args=[-3,-100],ref=-103}
        {args=[75883,65332],ref=75883 + 65332}
    ]
}

