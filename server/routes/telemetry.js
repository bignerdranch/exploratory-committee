const express = require('express');
const router = express.Router();
const Telemetry = require('../models/telemetry');

router.get('/', async (req, res, next) => {
  try {
    const telemetry = await Telemetry.find({ projectId: req.query.projectId });
    return res.send(telemetry);
  } catch (err) {
    console.log('err', err);
    res.status(500).send(err);
  }
});

router.post('/', async (req, res, next) => {
  try {
    const telemetry = await Telemetry.create({
      projectId: req.body.projectId,
      action: req.body.action,
      destinationScreen: req.body.destinationScreen,
      runId: req.body.runId,
      currentScreen: req.body.currentScreen,
      positionX: req.body.positionX,
      positionY: req.body.positionY,
    });
    return res.send(telemetry);
  } catch (err) {
    console.log('err', err);
    res.status(500).send(err);
  }
});

module.exports = router;
