Hints = hints -> _Mutable_new {
    // to be a "widget"
    class = widget.widget_class
    parent = null
    x = 0
    y = 0
    width = 0
    height = 0

    hint = 0
    text = widget.Text("Click for a hint.", align="center")

    size = g, width, height ->
        this.text.parent = this.parent
        this.text.size(g, width, height)
        this.width = this.text.width
        this.height = this.text.height

   draw = g, width, height ->
       this.text.draw(g, width, height)

   onmouse = x, y, event ->
       this.hint = 1 + this.hint % hints.size
       { this.hint == 0 }: this.text.setText("Show hint.")
       {                }: this.text.setText(hints[this.hint])
}
