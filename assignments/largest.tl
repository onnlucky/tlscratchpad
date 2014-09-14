{
    title = "Larger"
    text = "Create a function that receives two numbers and returns the largest of the two."
    hints = [
        "Compare numbers using '>' (larger) operator."
        "Read the function out loud: 'larger' is (=) a function (->) that takes an 'n1' and 'n2' and returns ..."
        "Use a thruth table using '{ cond }:' syntax"
    ]
    template = "larger = n1, n2 -> n1"
    tests = [
        {args=[1,2],ref=2}
        {args=[2,1],ref=2}
        {args=[354,40087],ref=40087}
        {args=[42,42],ref=42}
    ]
}
