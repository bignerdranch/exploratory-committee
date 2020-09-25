const mongoose = require('mongoose');

const ProjectSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  screens: {
    type: Array,
  },
});

module.exports = mongoose.model("Projects", ProjectSchema);