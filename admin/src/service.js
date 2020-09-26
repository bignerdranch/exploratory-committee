import axios from 'axios';

export default {
  getAllProjects() {
    return axios.get('https://immense-bastion-45421.herokuapp.com/')
      .then(res => res.data).catch(err => console.log('cant get all projects', err))
  },

  getProject(id) {
    return axios.get('https://immense-bastion-45421.herokuapp.com/project', { params: { id }})
      .then(res => res.data[0]).catch(err => console.log('cant get all projects', err))
  },

  addNewProject(name) {
    return axios.post('https://immense-bastion-45421.herokuapp.com/', { name })
      .then(res => res.data._id).catch(err => console.log('could not add new project', err))
  },

  saveScreens(id, screens) {
    return axios.post('https://immense-bastion-45421.herokuapp.com/screens', { id, screens })
      .then(res => res).catch(err => console.log('could not add new project', err))
  },

  getTelemetry(projectId) {
    return axios.get('http://localhost:3000/telemetry', { params: { projectId } })
      .then(res => res.data[0]).catch(err => console.log('cant get all projects', err))
  },
};