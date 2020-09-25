const express = require('express');
const router = express.Router();
const Project = require('../models/project');

router.post('/', async (req, res, next) => {
  try {
    const screens = await Project.updateOne(
      { _id: req.body.id },
      { $set: { screens: req.body.screens } },
      { timestamps: false },
    );
    res.send(screens);
  } catch (err) {
    res.status(500).send(err);
  }
});

module.exports = router;
