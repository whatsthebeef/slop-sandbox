import assert from 'node:assert/strict';
import { test } from 'node:test';
import { batteryPercent, isLow } from '../src/battery.js';

test('battery percent is clamped', () => {
  assert.equal(batteryPercent(1.4), 100);
  assert.equal(batteryPercent(-1), 0);
});

test('battery percent always rounds down', () => {
  assert.equal(batteryPercent(0.425), 42);
  assert.equal(batteryPercent(0.426), 42);
  assert.equal(batteryPercent(0.999), 99);
  assert.equal(batteryPercent(1), 100);
  assert.equal(batteryPercent(0.29), 29);
});

test('low battery is below 15%', () => {
  assert.equal(isLow(14), true);
  assert.equal(isLow(15), false);
});
