const express = require('express');
const router = express.Router();
const Project = require('../models/project');

router.get('/project', async (req, res, next) => {
  try {
    const project = await Project.find({ _id: req.query.id });
    return res.send(project);
  } catch (err) {
    res.status(500).send(err);
  }
});

router.post('/', async (req, res, next) => {
  try {
    const project = await Project.create({
      name: req.body.name,
    });
    return res.send(project);
  } catch (err) {
    res.status(500).send(err);
  }
});

router.get('/', async (req, res, next) => {
  try {
    const projects = await Project.find({});
    return res.send(projects);
  } catch (err) {
    res.status(500).send(err);
  }
});

module.exports = router;
