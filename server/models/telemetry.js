const mongoose = require('mongoose');

const TelemetraySchema = new mongoose.Schema({
  projectId: {
    type: String,
  },
  action: {
    type: String,
  },
  destinationScreen: {
    type: String,
  },
  runId: {
    type: String,
  },
  currentScreen: {
    type: String,
  },
  positionX: {
    type: Number,
  },
  positionY: {
    type: Number,
  },
});

module.exports = mongoose.model("Telemetry", TelemetraySchema);