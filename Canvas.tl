Circle = {
    bounds = -> return this.r * -1, this.r * -1, this.r, this.r
    draw = g ->
        g.arc(0, 0, this.r).stroke
}
circle = r, fill, stroke -> { class = Circle, { r, fill, stroke }}

Rect = {
    bounds = -> return this.width/-2, this.height/-2, this.width/2, this.height/2
    draw = g ->
        g.rectangle(this.width/-2, this.height/-2, this.width, this.height).stroke
}
rect = width, height, fill, stroke -> { class = Rect, { width, height, fill, stroke }}

Line = {
    bounds = -> return 0, 0, this.x, this.y
    draw = g -> g.moveTo(0, 0).lineTo(this.x, this.y).stroke
}
line = x, y, stroke -> { class = Line, { x, y, stroke }}

Move = {
    bounds = ->
        x, y, w, h = this.sub.bounds
        return x + this.x, y + this.y, w + this.x, h + this.y
    draw = g ->
        g.save
        g.translate(this.x, this.y)
        this.sub.draw(g)
        g.restore
}
move = x, y, sub -> { class = Move, { x, y, sub }}

Group = {
    bounds = ->
        b = _Mutable_new { x = 0, y = 0, w = 0, h = 0 }
        this.sub.each: s ->
            x, y, w, h = s.bounds
            b.x = min(b.x, x)
            b.y = min(b.y, y)
            b.w = max(b.w, w)
            b.h = max(b.h, h)
        return b.x, b.y, b.w, b.h
    draw = g ->
        this.sub.each: s -> s.draw(g)
}
group = -> { class = Group, sub = args.slice }


Canvas = arg, ref -> _Mutable_new {
    // to be a "widget"
    class = widget.widget_class
    parent = null
    visible = true
    x = 0
    y = 0
    width = 0
    height = 0

    drawing = group(circle(50), move(-100, 1, circle(50)))

    size = g, width, height ->
        this.width = width
        this.height = 103

    draw = g, width, height ->
        x, y, w, h = this.drawing.bounds
        sx = (this.width - 4) / (w - x)
        sy = (this.height - 4) / (h - y)
        scale = { sx <= sy }: sx
                {          }: sy
        print "scale:", scale, "WxH", this.width, this.height, "bounds", x, y, w, h
        g.translate(this.width / 2, this.height / 2)
        g.scale(scale, scale)
        //g.translate((x - w)/-2, (y - h)/-2)
        this.drawing.draw(g)
}

