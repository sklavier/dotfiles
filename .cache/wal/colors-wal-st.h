const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#040A10", /* black   */
  [1] = "#225DB1", /* red     */
  [2] = "#4875AB", /* green   */
  [3] = "#1F60C1", /* yellow  */
  [4] = "#3276C5", /* blue    */
  [5] = "#5486B8", /* magenta */
  [6] = "#3D83CB", /* cyan    */
  [7] = "#a1c2e1", /* white   */

  /* 8 bright colors */
  [8]  = "#70879d",  /* black   */
  [9]  = "#225DB1",  /* red     */
  [10] = "#4875AB", /* green   */
  [11] = "#1F60C1", /* yellow  */
  [12] = "#3276C5", /* blue    */
  [13] = "#5486B8", /* magenta */
  [14] = "#3D83CB", /* cyan    */
  [15] = "#a1c2e1", /* white   */

  /* special colors */
  [256] = "#040A10", /* background */
  [257] = "#a1c2e1", /* foreground */
  [258] = "#a1c2e1",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
