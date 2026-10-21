hl.config({
    animations = {
        enabled = true,
        bezier = {
            "overshot, 0.05, 1.15, 0.1, 1.3",
            "bounce, 0.3, 1.8, 0.5, 1.15",
            "spring, 0.2, 1.65, 0.35, 1.1",
        },
        animation = {
            "global, 1, 12, spring",
            "border, 1, 14, overshot",
            "windows, 1, 12, overshot, popin 85%",
            "windowsIn, 1, 13, spring, popin 85%",
            "windowsOut, 1, 10, bounce, popin 85%",
            "fadeIn, 1, 10, spring",
            "fadeOut, 1, 9, overshot",
            "fade, 1, 10, spring",
            "layers, 1, 12, overshot, popin 85%",
            "layersIn, 1, 13, spring, popin 85%",
            "layersOut, 1, 10, bounce, popin 85%",
            "fadeLayersIn, 1, 10, spring",
            "fadeLayersOut, 1, 9, overshot",
            "workspaces, 1, 11, bounce, slide",
            "specialWorkspace, 1, 12, spring, slidevert 20%",
        },
    },
})
