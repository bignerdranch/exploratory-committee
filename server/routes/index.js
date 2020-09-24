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

router.get('/:id', async (req, res, next) => {
  try {
    const project = await Project.find({ _id: id });
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

module.exports = router;
