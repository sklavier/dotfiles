static const char norm_fg[] = "#a1c2e1";
static const char norm_bg[] = "#040A10";
static const char norm_border[] = "#70879d";

static const char sel_fg[] = "#a1c2e1";
static const char sel_bg[] = "#4875AB";
static const char sel_border[] = "#a1c2e1";

static const char urg_fg[] = "#a1c2e1";
static const char urg_bg[] = "#225DB1";
static const char urg_border[] = "#225DB1";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
