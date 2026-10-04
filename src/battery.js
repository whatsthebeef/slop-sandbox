/**
 * Battery level as a whole percentage (0-100) from a raw 0-1 reading.
 * Always rounds down so a low reading never looks higher than it is; the epsilon
 * absorbs float error (0.29 * 100 is 28.999999999999996) so exact values keep their percent.
 */
export const batteryPercent = (reading) =>
  Math.floor(Math.min(Math.max(reading, 0), 1) * 100 + 1e-9);

/** Low battery is below 15%. */
export const isLow = (percent) => percent < 15;
