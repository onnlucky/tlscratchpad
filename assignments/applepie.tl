{
    title = "Baking an apple pie"
    text = "An normal apple pie is made with 400g of sugar, 300g of butter,
            350g of flour and 4 apples. But it happens often you don't have
            all the apples. In that case you can make a smaller pie. Write
            a funtion that given the amount of apples will return how much
            sugar, butter and flour to use by returning an object with a
            sugar, butter and flour property.
           "
    hints = [
        "Per apple you need ingredient / 4"
        "calculate on the dots {sugar=..., butter=..., flour=...}"
    ]
    template = "pie = apples -> {\n  sugar = 0\n  butter = 0\n  flour = 0\n}"
    tests = [
        {args=[4],ref={sugar=400,butter=300,flour=350}}
        {args=[1],ref={sugar=400/4,butter=300/4,flour=350/4}}
        {args=[3],ref={sugar=400/4*3,butter=300/4*3,flour=350/4*3}}
        {args=[6],ref={sugar=400/4*6,butter=300/4*6,flour=350/4*6}}
    ]
}

