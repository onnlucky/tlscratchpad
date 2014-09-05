#!/usr/bin/env gtl

w = Window.new 600, 400
w.title "Code Exercises"
b = Box.new 0, 0, w.width, w.height
w.add(b)
w.onresize(width, height -> b.width(width); b.height(height))
!(sleep 0.1; w.focus)

app = widget.App(w, b)
view = widget.Vertical()
app.setView(view)

w.onkey(event ->
    catch: e -> print e.toString
    app.onkey(event)
)
w.onmouse(x, y, buttons, clicks ->
    catch: e -> print e.toString
    view.onmouse({{x,y,buttons,clicks}}, x, y)
)
w.onmousescroll(dx, dy ->
    catch: e -> print e.toString
    view.onmousescroll(dx, dy)
)
b.ondraw(g ->
    catch: e -> print e.toString
    view.size(g, b.width, b.height)
    view.draw(g, b.width, b.height)
)

example = {
    title = "Example"
    text = "Create a function that receives a string, and returns the same string, but in all upper case letters."
    hints = [
        "Strings have a method called 'upper'."
        "Read the function out loud: 'uppercase' is (=) a function (->) that takes an 's' and ..."
    ]
    template = "uppercase = s -> s"
    tests = [
        {arg="hello",ref="HELLO"}
        {arg="world!",ref="WORLD!"}
    ]
}

assignment = { args[1] }: io.File(args[1]).readString.eval
             {         }: example

view.add(widget.Space(10))
view.add(widget.Text(assignment.title,style="bold"))
view.add(widget.Text(assignment.text))
view.add(widget.Space(10))
editor = Editor(assignment.template)
view.add(editor)
editor.setFocus
view.add(widget.Space(10))

tests = Array.new
assignment.tests.each(t ->
    result = Result(try(t.args, [t.arg]), try(t.refs,[t.ref]))
    view.add(result)
    tests.add(result)
)

view.add(widget.Space(20))

green = widget.Text("Well Done!", align="center", style="bold", color=[0,0.7,0])
view.add(green)

hints = Hints(try(assignment.hints,[]))
if try(assignment.hints): view.add(hints)

reline = Regex("line.([0-9]+)")
runchange = ->
    catch: e ->
        msg = try(e.msg, e) or "unknown"
        line = try(Number(reline.match(msg)[1]))
        print "line:", line
        editor.setErrorLine(line, msg)
        tests.each(r -> r.setError(""))
    code = editor.text
    fn = code.eval
    editor.setErrorLine(null)
    tests.each(test -> test.eval(fn))
    ok = tests.reduce(initial=true, (r, test -> r = r and test.status))
    green.setVisible(ok)
    hints.setVisible(not ok)
runchange()

dochange = Var.new 0
editor.onchange = ->
    $dochange += 1
    !(
        sleep 0.3
        x = ($dochange -= 1)
        if x > 0: return
        runchange()
     )

