w = Window.new 400, 800
w.title "widget test"
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

view.add(widget.Text("Create a function that takes a string, and returns the upper case."))
view.add(Editor("uppercase = s ->", readonly=true))
editor = Editor("  s.upper")
view.add(editor)
editor.setFocus
view.add(widget.Text(""))
result = Editor("uppercase(\"hello\") == \"HELLO\"", readonly=true)
view.add(result)

dochange = Var.new 0
editor.onchange = ->
    result.result = null
    $dochange += 1
    !(
        sleep 0.3
        x = ($dochange -= 1)
        if x > 0: return
        catch: e ->
            print e.toString
            result.result = false
        res = ("(s ->\n"+ editor.text +")(\"hello\")").eval == "HELLO"
        print "running:", res
        result.result = res
        result.parent.dirty
    )

editor.onchange
