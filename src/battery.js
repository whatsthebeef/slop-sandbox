/** Battery level as a whole percentage (0-100) from a raw 0-1 reading. */
export const batteryPercent = (reading) => Math.round(Math.min(Math.max(reading, 0), 1) * 100);

/** Low battery is below 15%. */
export const isLow = (percent) => percent < 15;
