using Images

@inline function hsv2rgb(h, s, v)
    c = v * s
    x = c * (1 - abs(((h/60) % 2) - 1))
    m = v - c

    r,g,b =
        if h < 60
            (c, x, 0)
        elseif h < 120
            (x, c, 0)
        elseif h < 180
            (0, c, x)
        elseif h < 240
            (0, x, c)
        elseif h < 300
            (x, 0, c)
        else
            (c, 0, x)
        end

    (r + m), (b + m), (g + m)
end

@inline function julia_calc(z, maxiter::Int64)
    c=-0.8+0.156im
    i=0
    while abs(z) < 2 && (i +=1) <= maxiter
        z = z^2 + c
    end
    return i
end
function julia_set(w::Int64, h::Int64, path)
    zoom = .75
    maxIter = 256
    img = Array{RGB{Float64}}(undef, h, w)
    Threads.@threads for x in 1:w
        Threads.@threads for y in 1:h
            c = Complex(
                (2*x - w) / (w * zoom),
                (2*y - h) / (h * zoom)
            )
            z = c
            i = julia_calc(z, maxIter)
            #r,g,b = hsv2rgb(i / maxIter * 360, 1, i / maxIter)
            r,g,b = hsv2rgb(180, i/maxIter,  i/maxIter)
            img[y,x] = RGB{Float64}(r, g, b)
        end
    end

    save(path, img)
end
path = "Z:\\documents\\GitHub\\Julia\\fractals\\output\\julia_set"
path = path + ARGS[1] + ".png"
julia_set(9000, 6000, path)
