const express = require('express');
const router = express.Router();
const Project = require('../models/project');

router.get('/', async (req, res, next) => {
  try {
    const projects = await Project.find({});
    res.send(projects);
  } catch (err) {
    res.status(500).send(err);
  }
});

router.get('/project', async (req, res, next) => {
  try {
    const project = await Project.find({ _id: req.query.id });
    console.log('project', project);
    res.send(project);
  } catch (err) {
    res.status(500).send(err);
  }
});

router.post('/', async (req, res, next) => {
  try {
    const test = await Project.create({
      name: req.body.name,
    });
    res.status(200);
  } catch (err) {
    res.status(500).send(err);
  }
});

router.put('/project', async (req, res, next) => {
  try {
    const project = await Project.updateOne(
      { _id: req.query.id },
      { $set: { screens: req.body.screens } },
      { timestamps: false });

    console.log('updating...........', project);
    res.send(project);
  } catch (err) {
    res.status(500).send(err);
  }
});

module.exports = router;
